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


all_img = []
 
cap = cv2.VideoCapture(video_path)
frame_count = [1]

def new_list(lens):
    x = [1] 
    for i in range(1,lens):
        x.append(x[-1] + 1)
    return x
    
def draw_circle(event,x,y,flags,param):
    if event == cv2.EVENT_LBUTTONDBLCLK:
        print(x,y)
    return (x,y)
#cv2.namedWindow('frame')
#cv2.setMouseCallback('frame', draw_circle)


# read the video
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
    

#count = 0
#while(cap.isOpened()):
#    ret, frame = cap.read()
#    count += 1 
#    if count % 100 == 0:
#        print(count)
#    if count % 3 == 0:
#        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) # 360 * 640 
#        gray = cv2.resize(gray, (int(640/4), int(360/4)), interpolation=cv2.INTER_CUBIC) # resize to 
#        imgs.append(gray)
#        
#        gray = cv2.fastNlMeansDenoising(gray,None,10,7,21)
#        region = gray 
#        region = gray[199:279,279:404]
#        region = gray[50:70,70:100]
#        all_img.append(sum(sum(region)))
        
#        cv2.imshow('frame',region)
#        if cv2.waitKey(1) & 0xFF == ord('q'):
#            break

#cap.release()
#cv2.destroyAllWindows()



#
#def bright_evaluate_average (video_path):        
#    ave_threshold = 15 * 720 * 576 * 3
#    cap = cv2.VideoCapture(video_path)
#    
#    while(cap.isOpened()):  
#        ret , frame = cap.read()         
#        if frame is None:
#            break    
#        s = frame.sum()
#        if s < ave_threshold:
#            return (False, s)
#        
#    return (True ,s)
#
#def bright_evaluate_topxx (video_path):  
#    top_threshold = 20 * 720 * 576 * 3 / 2 
#    cap = cv2.VideoCapture(video_path)
#    
#    while(cap.isOpened()):  
#        ret , frame = cap.read()         
#        if frame is None:
#            break    
#        frame = np.reshape(frame,(1244160))
#        s = sum(frame[int(len(frame)/2):])
#        if s < top_threshold:
#            return (False, s)    
#    return (True , s)
#
#print(len(all_videos))
#
#
#bright_top = []
#dark_top = [] 
#count = 1
#for i in all_videos:
#    if '.avi' in i:
#        print(count)
#        count +=1
#        is_bright , value = bright_evaluate_topxx(i)
#        if is_bright:
#            bright_top.append((i,value))
#        else:
#            dark_top.append((i,value))
#    else:
#        print(i)
#        
#
#bright = []
#dark = [] 
#
#count = 1
#for i in all_videos:
#    if '.avi' in i:
#        print(count)
#        count +=1
#        is_bright , value = bright_evaluate_topxx(i)
#        if bright_evaluate_average(i)[0]:
#            bright.append((i,value))
#        else:
#            dark.append((i,value))
#    else:
#        print(i)
#        
##find the top xx darkest for each methods
#top = 20
#
#value = [i[1] for i in dark ]
#value.sort()
#value = value[:top]
#x = { str(i) : j for j , i in dark }
#top20_dark = [ x[str(i)]for i in value]
#
#value = [i[1] for i in dark_top ]
#value.sort()
#value = value[:top]
#x = { str(i) : j for j , i in dark_top }
#top20_dark_top = [ x[str(i)]for i in value]   
#    