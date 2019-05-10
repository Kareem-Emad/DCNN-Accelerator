#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 14 20:36:41 2019

@author: haneen
"""

#this code reads json file and compresses it v2.0

import json

with open('CNN_info_Sample.json') as f:
    data = json.load(f)
    
layers = len(data['layers'])
#layerList = list()

types = list()
xs = list()
ys = list()
in_depths = list()
#in_depths.append(1)
out_depths = list()
#flag_in = 1
#print(flag_in)

for i in range(layers):
    
    layer = data['layers'][i]
    print('i', i)
    types.append(layer['layer_type'])
    
    flag_in = 0
    
    for element in layer:
        
        print('f', flag_in)
        
        if element == 'sx':
            xs.append(layer['sx'])
            if layer['sx'] > 5:
                print('error')
        elif element == 'sy':
            ys.append(layer['sy'])
            if layer['sy'] > 5:
                print('error')
        elif element == 'in_depth':
            in_depths.append(layer['in_depth'])
            print(i, 'in_depth', in_depths[-1])
            flag_in = 1
            if layer['in_depth'] > 8:
                print('error')
                
        elif element == 'out_depth':
            out_depths.append(layer['out_depth'])
            if layer['out_depth'] > 8:
                print('error')
        
        if element != 'filters':
            print(element, layer[element])
            
    if flag_in == 0:
            in_depths.append(out_depths[i-1])
            print(i, 'in_depth', in_depths[-1])
                
            
for i in range(1, layers):
    if(in_depths[i] != out_depths[i-1]):
        print('Incorrect in_depth', i, in_depths[i], out_depths[i-1])
#        exit()
        
bits = str()
bits += '{0:02b}'.format(layers)

print('bits of layers', bits)

for i in range(layers):
    
    bits += '{0:03b}'.format(data['layers'][i]['sx'])
    bits += '{0:03b}'.format(data['layers'][i]['sy'])
    bits += '{0:04b}'.format(data['layers'][i]['out_depth'])
    if data['layers'][i]['layer_type'] == 'conv':
        bits += '01'
    elif data['layers'][i]['layer_type'] == 'fc':
        bits += '10'
    else:
        bits += '11'
        
    if data['layers'][i]['layer_type'] == 'conv' or data['layers'][i]['layer_type'] == 'fc':
        for f in data['layers'][i]['filters']:
            for w in f['w'].values():
                if w > 1:
                    print('errooooooooooor')
                elif w > 0:
                    flag = 0
                else:
                    flag = 1
                    
                temp = abs(w)
                count = 0
                wb = str()
                
                while (temp != 0 and count < 16):
                    temp = temp * 2
                    wb += str(int(temp))
#                    print(temp, int(temp) ^ flag, count)
                    if temp >= 1:
                        temp -= 1
                    count += 1
                
                if flag == 1:
                    wb = bin(2**16 - int(wb, 2))
                    wb = wb[2:]
                    
                bits += str(wb)
#                print(w, wb)

#print(bits)
prev_i = bits[0]
count = 0
lines = str()

for i in bits:
    
    if prev_i == i and count < 127:
        count += 1
    else:
        lines += i
        lines += bin(count)[2:]
        count = 0
        
lines += i
lines += bin(count)[2:]
print (lines, len(lines)/8)

with open ("jsnC.txt",'w') as f:            
    f.write(lines)
