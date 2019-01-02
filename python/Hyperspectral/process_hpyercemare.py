# -*- coding: utf-8 -*-
"""
Created on Fri Nov 23 16:20:29 2018

@author: u5541673
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Nov 19 11:12:21 2018

@author: u5541673
"""

# -*- coding: utf-8 -*-
"""
Created on Sat Sep 22 19:06:18 2018

@author: gin
"""

# evaluate the the  of videos'brightness   in AFEW dataset  and increase the darks

import cv2 
import numpy as np
import os


import matplotlib.pyplot as plt




video_path = 'MultiCorder2 - Microsoft LifeCam Cinema(TM) - 19 December 2017 - 02-11-22 PM - 00002.mp4'
window_size = [(408,468),(1308,1075)]




all_img = []
 
cap = cv2.VideoCapture(video_path)
frame_count = [1]

def new_list(lens):
    x = [1] 
    for i in range(1,lens):
        x.append(x[-1] + 1)
    return x
    

    
count = 0 
imgs = []
while(cap.isOpened()):
    ret, frame = cap.read()
    count += 1 

    if count % 3 == 0:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) # 360 * 640 
        gray = cv2.resize(gray, (int(640/4), int(360/4)), interpolation=cv2.INTER_CUBIC) # resize to 
        gray = gray[50:70,70:100]
        imgs.append(gray)



count = 0
all_img = []
for gray in imgs:
    count += 1 
    if count % 100 == 0:
        print(count)
    
    region = gray
    region = cv2.fastNlMeansDenoising(region,None,12,7,21)
    
#    dst = cv2.fastNlMeansDenoisingMulti(noisy, 2, 5, None, 4, 7, 35)
    
    all_img.append(sum(sum(region)))    
    

#
count = 0
all_img = []

for i in range (2,len(imgs)-2):
    count += 1 
    if count % 100 == 0:
        print(count)    
    dst = cv2.fastNlMeansDenoisingMulti(imgs, i, 5, None, 10,7,21)
    all_img.append(sum(sum(dst)))

#ave = sum(all_img)/ len(all_img)

plt.figure()
frame_count = new_list(len(all_img))
plt.plot(frame_count,all_img)
plt.savefig("easyplot.jpg")
    
