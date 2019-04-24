# This is a model for control and addressing. It is not cycle-accurate. It is meant as a quick way to test out ideas and to help us write the code.
import numpy as np

IMSIZE = 16
np.set_printoptions(precision=2)


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
    img = np.random.randn(IMSIZE, IMSIZE)
    # img = 9 * np.ones((IMSIZE, IMSIZE))
    nlayers = 3
    layer_types = np.array([0, 0, 2])  # 0 = convolution, 1 = average pooling, 2 = FC
    flt_nfilters = np.array([2, 2, 3])
    flt_sizes = np.array([5, 3, 5])
    layer_dims = [IMSIZE]
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
        print(layer_dims[i + 1])
        newSizeSquared = layer_dims[i + 1] * layer_dims[i + 1]
        mem = np.append(mem, [layer_types[i], flt_nfilters[i], flt_sizes[i], layer_dims[i + 1], newSizeSquared,
                              layer_dims[i + 1] * layer_dims[i + 1] * flt_nfilters[i]])
        if layer_types[i] == 0:
            for j in range(flt_nfilters[i]):
                bias = 0
                mem = np.append(mem, bias)
                for ch in range(n_in_channels):
                    # flt2d = np.reshape(np.random.randint(1, 5) * np.ones((flt_sizes[i], flt_sizes[i])), -1)
                    flt2d = np.reshape(np.random.randn(flt_sizes[i], flt_sizes[i]) , -1)
                    mem = np.append(mem, flt2d)
        elif layer_types[i] == 2:
            prev_size = int(layer_dims[i])
            num_elem = int(prev_size / 5) * 5
            NewNumChannels = (num_elem / 5) * (num_elem / 5)
            mem = np.append(mem, NewNumChannels)
            for j in range(flt_nfilters[i]):
                for i in range(10):
                    mem = np.append(mem, np.random.randn(num_elem, num_elem))

    # mem = np.append(mem, img)
    # outp_addr = mem.size - img.size
    # print(mem[0:])
    mem = np.append(mem, np.zeros(65536 - mem.size))
    outp_addr = 39000
    mem[outp_addr:outp_addr + img.size] = img.flatten().copy()
    return mem, outp_addr

# Start of Control Model.


def fetch_layer_info(mem, flt_addr, ImgWidth, ImgHeight, ImgChannels):
    layer_type = int(mem[flt_addr])  # Get the type of the layer
    flt_addr += 1
    nflt_layer = int(mem[flt_addr])  # Get the number of filters in layer.
    flt_addr += 1
    flt_size = int(mem[flt_addr])  # Get the filter size
    flt_addr += 1
    NewWidth = int(mem[flt_addr])  # Get the new image size
    flt_addr += 1
    NewHeight = NewWidth
    NewSizeSquared = int(mem[flt_addr])  # Get the new image size * size
    flt_addr += 1
    # Get the total memory area taken by the following layer.
    LayerMemSize = int(mem[flt_addr])
    flt_addr += 1
    if (layer_type == 2):
        NewNumChannels = int(mem[flt_addr])
        flt_addr += 1
        ImgChannels = NewNumChannels
        ImgWidth = 5
        ImgHeight = 5
    return flt_addr, layer_type, nflt_layer, flt_size, NewWidth, NewHeight, NewSizeSquared, LayerMemSize, ImgChannels, ImgWidth, ImgHeight


def init_filter(mem, flt_size, flt_addr, IsPoolLayer):
    if (IsPoolLayer):
        return np.array([]), flt_addr
    flt_Imax = flt_size * flt_size
    flt_data = np.zeros(flt_Imax)
    for i in range(flt_Imax):  # Load filter data.
        flt_data[i] = mem[flt_addr]
        flt_addr += 1
    flt_data = np.reshape(flt_data, (flt_size, flt_size))
    return flt_data, flt_addr


# Loads a widthxheight subblock of the image.
def init_cache(mem, base_addr, offset_addr, width, height, rowCounter, colCounter):
    cache = np.zeros((5, IMSIZE))
    heightMax = 5
    widthMax = np.min([IMSIZE, width])
    for h in range(5):
        for w in range(widthMax):
            cache[h][w] = mem[base_addr + offset_addr]
            offset_addr = offset_addr + 1
    return cache, 1, offset_addr, 5, 0


def init_window(cache, img_window, should_init_window, ImgWindowCol):
    # print("should_init_window = %d" % should_init_window)
    if should_init_window == 1:
        should_init_window -= 1
        return cache[:, 0:5].copy(), 5, should_init_window
    else:
        if should_init_window == 2:
            should_init_window -= 1
        return img_window, ImgWindowCol, should_init_window


def start_convolution(mem, img_window, flt_data, current_channel, bias_base_addr, bias_offset_addr, flt_size, flt_bias, IsPoolLayer, IsFCLayer):
    output1 = 0
    output2 = 0
    if IsPoolLayer:
        if flt_size == 5:
            output1 = np.mean(img_window)
        else:
            output1 = np.mean(img_window[0:3, 0:3])
            output2 = np.mean(img_window[0:3, 1:4])
    else:
        bias1 = 0
        bias2 = 0
        if current_channel == 0:
            if not IsFCLayer:
                bias1 = flt_bias
            else:
                bias1 = 0
        else:
            bias1 = mem[bias_base_addr + bias_offset_addr]
            bias_offset_addr = bias_offset_addr + 1
        if flt_size == 5:
            output1 = np.sum(np.multiply(img_window, flt_data)) + bias1
        else:
            if current_channel == 0:
                bias2 = flt_bias
            else:
                bias2 = mem[bias_base_addr + bias_offset_addr]
                bias_offset_addr = bias_offset_addr + 1
            output1 = np.sum(np.multiply(img_window[0:3, 0:3], flt_data)) + bias1
            output2 = np.sum(np.multiply(img_window[0:3, 1:4], flt_data)) + bias2
    return output1, output2


def fetch_to_cache(mem, cache, col, row, maxWidth, maxHeight, base_addr, offset_addr, flt_size):
    if flt_size == 3:
        niter = 2
    else:
        niter = 1
    for i in range(niter):
        if row < maxHeight:
            new_pixel = mem[base_addr + offset_addr]
            offset_addr += 1
        else:
            new_pixel = 0
        cache[0:4, col] = cache[1:5, col]
        cache[4, col] = new_pixel
        col += 1
        if (col >= maxWidth):
            col = 0
            row = row + 1
    return col, row, offset_addr


def fetch_to_image_window(cache, img_window, col, maxWidth, flt_size, should_init_window):
    if flt_size == 3 and col < maxWidth - 2:
        n_iter = 2
    else:
        n_iter = 1
    for i in range(n_iter):
        img_window[:, 0:4] = img_window[:, 1:5]
        img_window[:, 4] = cache[:, col].copy()
        col = col + 1
    if col >= maxWidth:
        col = 0
        should_init_window = 2
    return col, should_init_window


def write_to_mem(mem, flt_size, outp1, outp2, write_addr_base, write_addr_offset):
    if flt_size == 5:
        mem[write_addr_base + write_addr_offset] = outp1
        write_addr_offset = write_addr_offset + 1
    else:
        mem[write_addr_base + write_addr_offset] = outp1
        write_addr_offset = write_addr_offset + 1
        mem[write_addr_base + write_addr_offset] = outp2
        write_addr_offset = write_addr_offset + 1
    return write_addr_offset


def dcnn_sim(mem, outp_addr):
    flt_addr = 0

    ImgWidth = IMSIZE
    ImgHeight = IMSIZE
    ImgChannels = 1

    img_base_addr = outp_addr
    img_offset_addr = 0

    write_addr_base = outp_addr + IMSIZE * IMSIZE
    write_addr_offset = 0
    write_addr_base_prev = 0

    colCounter = 0
    rowCounter = 5

    imgWindowCol = 5

    img_window = np.zeros((5, 5))

    should_init_window = 0

    # Fetch the number of layers
    nlayers = int(mem[flt_addr])
    flt_addr += 1
    for i in range(nlayers):
        # Fetch layer info
        print("Layer " + str(i) + "!")
        flt_addr, layer_type, nflt_layer, flt_size, NewWidth, NewHeight, NewSizeSquared, LayerMemSize, ImgChannels, ImgWidth, ImgHeight = fetch_layer_info(mem, flt_addr, ImgWidth, ImgHeight, ImgChannels)
        IsConvLayer = (layer_type == 0)
        IsPoolLayer = (layer_type == 1)
        IsFCLayer = (layer_type == 2)
        for j in range(nflt_layer):
            print("\tFilter %d!" % j)
            if (IsConvLayer):
                flt_bias = mem[flt_addr]
                flt_addr += 1
            else:
                flt_bias = 0
            if j == 0:
                write_addr_base_prev = write_addr_base
            should_init_window = 1
            for ch in range(ImgChannels):
                print("\t\tChannel %d started! Reading Image from (%d, %d)!" % (ch, img_base_addr, img_offset_addr))
                flt_data, flt_addr = init_filter(mem, flt_size, flt_addr, IsPoolLayer)
                cache, should_init_window, img_offset_addr, rowCounter, colCounter = init_cache(mem, img_base_addr, img_offset_addr, ImgWidth, ImgHeight, rowCounter, colCounter)
                print("Filter: \n", flt_data, "\nCache: \n", cache, "\n")
                # print(ImgHeight, ImgWidth)
                # print(ImgHeight - flt_data.shape[0])
                # print(ImgWidth - flt_data.shape[0])
                # right_subimage = cache[5 - flt_data.shape[0]:, ImgWidth - flt_data.shape[0]: ImgWidth]
                # print("Right_subfilter = ", right_subimage)
                # conv_outp0 = np.dot(flt_data.flatten(), right_subimage.flatten())
                # print("Last element = %f" % conv_outp0)
                # right_subimage = cache[5 - flt_data.shape[0]:, ImgWidth - flt_data.shape[0]: ImgWidth]
                # print("Right_subfilter = ", right_subimage)
                # conv_outp0 = np.dot(flt_data.flatten(),
                #                     right_subimage.flatten())
                # print("Last element = %f" % conv_outp0)
                while write_addr_offset != NewSizeSquared:
                    img_window, imgWindowCol, should_init_window = init_window(
                        cache, img_window, should_init_window, imgWindowCol)
                    outp1, outp2 = start_convolution(
                        mem, img_window, flt_data, ch, write_addr_base, write_addr_offset, flt_size, flt_bias, IsPoolLayer, IsFCLayer)
                    if should_init_window == 0:
                        colCounter, rowCounter, img_offset_addr = fetch_to_cache(
                            mem, cache, colCounter, rowCounter, ImgWidth, ImgHeight, img_base_addr, img_offset_addr, flt_size)
                        imgWindowCol, should_init_window = fetch_to_image_window(
                            cache, img_window, imgWindowCol, ImgWidth, flt_size, should_init_window)
                    write_addr_offset = write_to_mem(mem, flt_size, outp1, outp2, write_addr_base, write_addr_offset)
                write_addr_offset = 0
                # rowCounter = 5
                # colCounter = 0
                # imgWindowCol = 5
                # break
            # break
            print("\tFilter %d Output at Address %d:\n" % (j, write_addr_base), np.reshape(mem[write_addr_base:write_addr_base + NewSizeSquared], (NewWidth, NewHeight)), "\n")
            img_offset_addr = 0
            write_addr_base += NewSizeSquared
        # We just finished processing the last filter of the layer. Prepare for the new layer..
        # if (j == nflt_layer - 1):
        img_base_addr = write_addr_base_prev
        # img_offset_addr = 0
        write_addr_base += LayerMemSize
        write_addr_offset = 0
        ImgChannels = nflt_layer
        ImgHeight = NewHeight
        ImgWidth = NewWidth
    # argmax computation goes here...


# Create the memory
mem, outp_addr = create_memory()
# print(mem)
print(mem.shape)
dcnn_sim(mem, outp_addr)

# -- for i in range(nlayers):
#             -- FetchLayerInfo()
#             -- for j in range(nflt_layer):
#             -- FetchFilterBias()
#             -- for ch in range(ImgChannels):
#             -- Init_Filter()
#             -- Init_Cache()
#             -- while write_addr_offset < new_size_squared:
#             -- Init_Window()
#             -- Start Convolution()
#             -- Fetch To Cache()
#             -- Fetch to Image Window()
#             -- Write to Memory()
#             -- clean_up_1
#             -- (write_addr_offset=0, rowCounter=5, colCounter=0, imgWindowCol=5)
#             -- clean_up_2
#             -- (img_offset_addr=0, write_addr_base += NewSizeSquared, new layer prep)

