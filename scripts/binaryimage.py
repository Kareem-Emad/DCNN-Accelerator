# -*- coding: utf-8 -*-
"""
Created on Sun Mar 17 00:44:45 2019

@author: hagar
"""

import numpy as np
import cv2
import re

def Encode (nbits,integ):
    st=""
    p=bin(integ)
    for l in range (nbits-(len(p)-2)): 
        st+='0'
    for k in range(2,len(p)): # 0b100 so discard 0b
            st+=p[k]
    return st

img = cv2.imread('Input_Sample.bmp')
#img = cv2.imread('img_1.jpg')
x,y,z=(img.shape)
image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
s=""
for i in range(x):
    for j in range(y):
        if image[i][j] <128:  # threshold value
            s+='0'
        else:
            s+='1'
            
print(s)
# print(len(s)) # (28*28)=784
# m=max(max(len(i) for i in re.findall(r'1+', s)),max(len(i) for i in re.findall(r'0+', s)))
# bits =int(np.ceil(np.log2(m)))
bits=7
print(bits)
compressed =""
now=s[0] 
count=1
cnt=0
packet=0
for i in range (1,len(s)):
    if s[i] != now or count == 2**bits-1: # can't exceed 127 as we have only 7 bits to represent them
        compressed+=now+Encode(bits,count)
        print (now," is added ",count," times.")
        cnt+=count
        packet+=1
        now=s[i]
        count=1

    else :
        count+=1
compressed+=now+Encode(bits,count)
print (now," is added ",count," times.")
cnt+=count
packet+=1
# print(len(compressed))
# print(compressed)
print(cnt)
print(packet)
with open ("img.txt",'w') as f:
    f.write(compressed)
# print(28*28*8)
