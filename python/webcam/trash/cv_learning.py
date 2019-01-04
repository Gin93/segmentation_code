# -*- coding: utf-8 -*-
"""
Created on Mon Nov 19 13:05:49 2018

@author: u5541673
"""

import cv2
import numpy as np

ix,iy = -1,-1
# mouse callback function
def draw_circle(event,x,y,flags,param):
    global ix,iy
    if event == cv2.EVENT_LBUTTONDBLCLK:
        cv2.circle(img,(x,y),100,(255,0,0),-1)
        ix,iy = x,y

# Create a black image, a window and bind the function to window
img = np.zeros((512,512,3), np.uint8)
cv2.namedWindow('image')
cv2.setMouseCallback('image',draw_circle)

while(1):
    cv2.imshow('image',img)
    k = cv2.waitKey(1) & 0xFF
    if k == 27:
        break
    elif k == ord('a'):
        print (ix,iy)
cv2.destroyAllWindows()