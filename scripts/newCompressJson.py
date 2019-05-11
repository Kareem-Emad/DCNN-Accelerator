#this code reads json file and compresses it v3.0

import json
import numpy as np

with open('CNN_info_Sample.json') as f:
    data = json.load(f)
    
#get number of layers and write it to unCompressed data
layers = len(data['layers'])
print('number of layers ', layers)
unCompressed = str(np.binary_repr(layers, 16))
print('after adding layers number,', 'number of layers', layers, 'binary_repr', str(np.binary_repr(layers, 16)))
# unCompressed += "\n"
########################################################################################################


#used with fc to calculate number of channels
out_sx_of_previous = list()

#exponent, the amount of shift for weights and biases, to convert them to integer
exponent = 14

for i in range(layers):

	#get a layer
    layer = data['layers'][i]
    print('i', i)
    
    #get layer type
    if layer['layer_type'] == 'conv':
        layer_type = 0
    elif layer['layer_type'] == 'fc':
        layer_type = 2
    else:
        layer_type = 1 

    #write layer type to unCompressed data
    unCompressed += str(np.binary_repr(layer_type, 16))
    print('after layer type,', 'type', layer_type, 'binary_repr', str(np.binary_repr(layer_type, 16)))
    #unCompressed += "\n"

    #get filter size
    if layer_type == 1:
    	filter_size = 1

    elif layer_type == 2:
    	filter_size = 5

    else:
    	filter_size = layer['sx']

    #append layer size to out sizes
    out_sx_of_previous.append(filter_size)

    #write filter size to unCompressed data
    unCompressed += str(np.binary_repr(filter_size, 16))
    print('after filter size,', filter_size, 'binary_repr', str(np.binary_repr(filter_size, 16)))
    #unCompressed += "\n"


    #get new layer size
    if layer_type == 2:
    	new_layer_size = 1
    else:
    	new_layer_size = layer['out_sx']

    #write new layer size to unCompressed data
    unCompressed += str(np.binary_repr(new_layer_size, 16))
    print('after new layer size,', 'new_layer_size', new_layer_size, 'binary_repr', str(np.binary_repr(new_layer_size, 16)))
    #unCompressed += "\n"

	#write new layer size * new layer size to unCompressed data
    unCompressed += str(np.binary_repr(new_layer_size * new_layer_size, 16))
    print('after new layer size^2,', 'new_layer_size^2', new_layer_size*new_layer_size, 'binary_repr', str(np.binary_repr(new_layer_size * new_layer_size, 16)))
    #unCompressed += "\n"    


    if layer_type == 1:
    	filters = 1

    else:
    	filters = len(layer['filters'])

    #write new layer size * new layer size * filters in current layer to unCompressed data
    unCompressed += str(np.binary_repr(new_layer_size * new_layer_size * filters , 16))
    print('after new layer size^2*filters,', 'new_layer_size^2*filters', new_layer_size*new_layer_size*filters, 'binary_repr', str(np.binary_repr(new_layer_size * new_layer_size * filters , 16)))
    #unCompressed += "\n"


    if layer_type == 2:
    	n_in_channels = np.math.floor(out_sx_of_previous[i-1] * out_sx_of_previous[i-1] / 25.0)
    	unCompressed += str(np.binary_repr(new_layer_size * new_layer_size * n_in_channels , 16))
    	print('after channels in fc,', 'new_layer_size*new_layer_size*nChannels', new_layer_size*new_layer_size*n_in_channels, 'binary_repr', str(np.binary_repr(new_layer_size * new_layer_size * n_in_channels , 16)))
    	print('n_in_channels', n_in_channels)
        #unCompressed += "\n"

    #write bias before filter
    if layer_type != 1:
        print('number of filters in layer,', len(layer['filters']))
        for f in range(len(layer['filters'])):
            bias = layer['biases']['w'][str(f)]
            bias = int(bias * (2**exponent))
            unCompressed += str(np.binary_repr(bias, 16))
            print('after bias,', 'bias after multiplying by exponent', bias, 'binary_repr', str(np.binary_repr(bias, 16)))
    		#unCompressed += "\n"

            if layer_type == 0:
                depth = new_layer_size
            elif layer_type == 2:
                depth = int(layer['num_inputs']/25.0)*25

            print('depth of layer, of type', layer_type, 'depth', depth)
                
            print('depth', depth)

            for d in range(depth):
                weight = layer['filters'][f]['w'][str(d)]
                weight = int(weight * (2**exponent))
                unCompressed += str(np.binary_repr(weight, 16))
                # print('after weight,', 'weight after multiplying by exponent', weight, 'binary_repr', str(np.binary_repr(weight, 16)))
                # unCompressed += "\n"
    			

print('\n\n')



count = 1
prev_bit = unCompressed[0]
compressed = str()


for i in range(1, len(unCompressed)):
    if prev_bit == unCompressed[i] and count < 127:
        count += 1

    else:
        compressed += prev_bit
        compressed += str(np.binary_repr(count, 7))
        prev_bit = unCompressed[i]
        print('prev_bit', prev_bit, 'count', count)
        count = 1

print(len(unCompressed))

with open ("jsnUn.txt",'w') as f:            
    f.write(unCompressed)

with open ("jsnC.txt",'w') as f:            
    f.write(compressed)







