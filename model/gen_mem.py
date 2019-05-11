from enum import Enum
import numpy as np
from scipy import signal

IM_SIZE = 28
EXPONENT = 6

np.random.seed(1)
np.set_printoptions(precision=3, suppress=True)


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
    img = np.random.randint(0, high=256, size=IM_SIZE * IM_SIZE)
    img2d = np.reshape(img, (IM_SIZE, IM_SIZE))
    for i in range(IM_SIZE):
        for j in range(IM_SIZE):
            print(img2d[i][j], end=" ")
        print("\n")
    nlayers = 4
    # 0 = convolution, 1 = average pooling, 2 = FC
    layer_types = np.array([0, 1, 0, 2])
    flt_nfilters = np.array([3, 1, 1, 10])
    flt_sizes = np.array([5, 3, 5, 5])
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
    finals = np.zeros(10)
    curr_img = np.zeros((10, IM_SIZE, IM_SIZE))
    curr_img[0, :, :] = img2d[:, :]
    for i in range(nlayers):
        if i == 0:
            n_in_channels = 1
        else:
            if layer_types[i] == 2:
                # FIXME: what if the user starts on an FC?
                flt_nfilters[i] = 10
                flt_sizes[i] = 5
                prev_size = int(layer_dims[i])
                n_in_channels = np.math.floor(prev_size * prev_size / 25.0)
                layer_dims[i + 1]
            else:
                j = i - 1
                while j >= 0 and layer_types[j] == 1:
                    j = j - 1
                if j == -1:
                    n_in_channels = 1
                else:
                    n_in_channels = flt_nfilters[j]
        # print(layer_dims[i + 1])
        newSizeSquared = layer_dims[i + 1] * layer_dims[i + 1]
        if layer_types[i] == 1:
            totalLayerMemSize = layer_dims[i + 1] * layer_dims[i + 1] * n_in_channels
        else:
            totalLayerMemSize = layer_dims[i + 1] * layer_dims[i + 1] * flt_nfilters[i]
        mem = np.append(mem, [layer_types[i], flt_nfilters[i], flt_sizes[i], layer_dims[i + 1], newSizeSquared, totalLayerMemSize])
        if layer_types[i] == 2:
            print(n_in_channels)
            mem = np.append(mem, n_in_channels)
        inp_image_to_layer = curr_img.copy()
        for j in range(flt_nfilters[i]):
            if layer_types[i] == 0:
                bias = 46  # np.random.randint(0, 20)
                mem = np.append(mem, bias)
            elif layer_types[i] == 2:
                print("\nStarting FC Layer filter..")
                flattened_inp = np.reshape(inp_image_to_layer[:, :layer_dims[i], :layer_dims[i]], -1)
                size_to_take = int(n_in_channels * 5 * 5)
                inp_image_to_layer = np.reshape(
                    flattened_inp[:size_to_take], (n_in_channels, 5, 5))
                bias = 0
                mem = np.append(mem, bias)
            else:
                bias = 0
            conv_outp = np.zeros((layer_dims[i + 1], layer_dims[i + 1])) + bias
            outp_width, outp_height = conv_outp.shape
            for ch in range(n_in_channels):
                # flt2d = np.random.randint(0, 20, size=flt_sizes[i] * flt_sizes[i])
                # flt2d = np.arange(flt_sizes[i] * flt_sizes[i]) * 2
                raw_flt2d = np.random.randint(-256, 256, size=flt_sizes[i] * flt_sizes[i])
                flt2d = np.flip(np.reshape(
                    raw_flt2d, (flt_sizes[i], flt_sizes[i])), axis=0)
                if layer_types[i] == 1:
                    flt2d = np.ones((flt_sizes[i], flt_sizes[i]))
                    if flt_sizes[i] == 3:
                        flt2d = flt2d / (2**3)
                    else:
                        flt2d = flt2d / (2**5)
                flt1d = np.reshape(flt2d, -1)
                conv_inp = inp_image_to_layer[ch, :layer_dims[i], :layer_dims[i]]
                if layer_types[i] == 1:
                    conv_outp = np.array((signal.convolve(conv_inp, np.flip(
                        flt2d, axis=1), mode='valid')) / (2**EXPONENT))
                    conv_outp = np.floor(conv_outp)
                    curr_img[ch, :outp_width, :outp_height] = conv_outp[:, :]
                else:
                    conv_outp += np.array((signal.convolve(conv_inp, np.flip(
                        flt2d, axis=1), mode='valid')) / (2**EXPONENT), dtype=int)
                    mem = np.append(mem, flt1d)
                print(conv_outp.shape)
                print("Channel %d of Filter %d of layer %d: " % (ch, j, i), "\n", flt2d)
                print("Convolution Input for this channel: \n", conv_inp)
                print("Convolution Output for this channel: \n", conv_outp)
            if layer_types[i] == 2:
                finals[j] = conv_outp
            print("******* THAT WAS THE FINAL OUTPUT OF THIS FILTER ************\n")
            if layer_types[i] == 0:
                curr_img[j, :outp_width, :outp_height] = conv_outp[:, :] * (conv_outp[:, :] >= 0)
                print("Final channel convolution output: \n",
                      curr_img[j, :outp_width, :outp_height])
            elif layer_types[i] == 2:
                curr_img[j, :outp_width, :outp_height] = conv_outp[:, :]
            print("\n")
    print("Final class scores: \n", finals)
    data_addr = mem.size
    # mem = np.append(mem, img)
    # outp_addr = mem.size - img.size
    # print(mem[0:])
    mem = np.append(mem, np.zeros(65536 - mem.size))
    outp_addr = 39000
    mem[outp_addr:outp_addr + img.size] = img.flatten().copy()
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
