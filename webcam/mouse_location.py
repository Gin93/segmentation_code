# -*- coding: utf-8 -*-
"""
Created on Fri Nov 23 16:06:03 2018

@author: u5541673
"""


import cv2 
import numpy as np
import os


import matplotlib.pyplot as plt

def draw_circle(event,x,y,flags,param):
    if event == cv2.EVENT_LBUTTONDBLCLK:
        print(x,y)
    return (x,y)
    
    
video_path = r'C:\Users\u5541673\Desktop\WHO\c.mp4'


all_img = []
 
cap = cv2.VideoCapture(video_path)
    
cv2.namedWindow('frame')
cv2.setMouseCallback('frame', draw_circle)
    
count = 0
while(cap.isOpened()):
    ret, frame = cap.read()
    
    cv2.imshow('frame',frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()


#408 468
#1308 1075

#small area 
#507 490
#1036 1075