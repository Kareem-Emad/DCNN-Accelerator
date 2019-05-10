from enum import Enum
import numpy as np
from scipy import signal

IM_SIZE = 28
EXPONENT = 6


# The memory is structured as follows:
#   ### Input Area
#   Number of Layers (1 word)
#   For i in range(nlayers):
#       Layer type.
#       Number of Filters in Layer[i] (In pooling, should be the same number as the input layer).
#       Filter Size
#       New Layer Size
#       New Layer Size * New Layer Size (space taken by one output channel)
#       New Layer Size * New Layer Size * Number of Filters in Layer[i] (i.e. the total space taken up by this layer at the end)
#       (For FC layer only) The new number of channels.
#       If not pooling
#           For j in range(flt_nfilters[i]):
#               Filter[i, j] Bias
#               For k in range(flt_nchannels[i]):
#                   Filter Channel[i, j, k] Data [Size x Size]
#   ### Output Area
#   Image (IMSIZExIMSIZE words)
#
#   Memory size needed: In the worst case, we have three 3x3 convolutional layers, each having 8 filters, followed by the FC. This is
#   28 x 28 (image) + 26 x 26 x 8 (1st layer output) + 24 x 24 x 8 (2nd layer output) + 22 x 22 x 8 (3rd layer output) +
#   8 x 3 x (3 x 3 + 1) (conv layer filters) + 22 x 22 x 8 x 10 (FC layer filters) + 10 (FC Layer outputs) + 1 Argmax Output
#   + 4 x 7 (Layer overhead)
#   = 53671 words = 54K => 16 bit memory (!)
#   The following function creates that memory, populated with random numbers.
def create_memory():
    # img = np.random.randn(IMSIZE, IMSIZE)
    # img = 9 * np.ones((IMSIZE, IMSIZE))
    img = np.arange(0, IM_SIZE * IM_SIZE, 1)
    img2d = np.reshape(img, (IM_SIZE, IM_SIZE))
    nlayers = 1
    # 0 = convolution, 1 = average pooling, 2 = FC
    layer_types = np.array([0, 0, 2])
    flt_nfilters = np.array([1, 2, 3])
    flt_sizes = np.array([5, 3, 5])
    layer_dims = [IM_SIZE]
    for i in range(1, nlayers + 1):
        if layer_types[i - 1] == 2:
            new_layer_size = 1
        elif flt_sizes[i - 1] == 5:
            new_layer_size = layer_dims[i - 1] - 4
        else:
            new_layer_size = layer_dims[i - 1] - 2
        layer_dims.append(new_layer_size)
    mem = np.append(np.array([]), nlayers)
    for i in range(nlayers):
        if i == 0:
            n_in_channels = 1
        else:
            n_in_channels = flt_nfilters[i - 1]
        # print(layer_dims[i + 1])
        newSizeSquared = layer_dims[i + 1] * layer_dims[i + 1]
        mem = np.append(mem, [layer_types[i], flt_nfilters[i], flt_sizes[i], layer_dims[i + 1], newSizeSquared,
                              layer_dims[i + 1] * layer_dims[i + 1] * flt_nfilters[i]])
        if layer_types[i] == 0:
            for j in range(flt_nfilters[i]):
                bias = 46  # np.random.randint(0, 20)
                mem = np.append(mem, bias)
                for ch in range(n_in_channels):
                    # flt2d = np.reshape(np.random.randint(1, 5) * np.ones((flt_sizes[i], flt_sizes[i])), -1)
                    flt2d = np.arange(flt_sizes[i] * flt_sizes[i]) * 2
                    flt2d = np.flip(np.reshape(flt2d, (flt_sizes[i], flt_sizes[i])), axis=0)
                    flt1d = np.reshape(flt2d, -1)
                    conv_outp = (signal.convolve(img2d, np.flip(flt2d, axis=1), mode='valid') + bias) / (2**EXPONENT)
                    print(conv_outp)
                    print(flt2d)
                    # flt2d = np.random.randint(0, 20, size=flt_sizes[i] * flt_sizes[i])
                    mem = np.append(mem, flt1d)
        elif layer_types[i] == 2:
            prev_size = int(layer_dims[i])
            num_elem = int(prev_size / 5) * 5
            NewNumChannels = (num_elem / 5) * (num_elem / 5)
            mem = np.append(mem, NewNumChannels)
            for j in range(flt_nfilters[i]):
                for i in range(10):
                    mem = np.append(mem, np.random.randn(num_elem, num_elem))
    data_addr = mem.size
    # mem = np.append(mem, img)
    # outp_addr = mem.size - img.size
    # print(mem[0:])
    mem = np.append(mem, np.zeros(65536 - mem.size))
    outp_addr = 39000
    mem[outp_addr:outp_addr + img.size] = img.flatten().copy()
    img = np.reshape(img, (IM_SIZE, IM_SIZE))
    # for i in range(IM_SIZE):
    #     for j in range(IM_SIZE):
    #         print(img[i][j], end="\t")
    #     print("\n")
    return mem, outp_addr, data_addr


mem, outp_addr, data_addr = create_memory()
# print(mem)


def write_memory(mem, outp_addr, data_addr, file_name):
    file = open(file_name, "w")
    file.write("// memory data file(do not edit the following line - required for mem load use)\n // instance=/ram_inst/ram\n // format=mti addressradix=d dataradix=b version=1.0 wordsperline=1\n")
    for mem_addr in range(data_addr):
        value = np.binary_repr(int(mem[mem_addr]), 16)
        file.write("\t" + str(mem_addr) + ": " + value + "\n")
    for mem_addr in range(outp_addr, outp_addr + IM_SIZE * IM_SIZE):
        value = np.binary_repr(int(mem[mem_addr]), 16)
        file.write("\t" + str(mem_addr) + ": " + value + "\n")
    print("Wrote out memory file to %s!" % file_name)

write_memory(mem, outp_addr, data_addr, "../scripts/memory.mem")
# def test_out_conv(mem):
