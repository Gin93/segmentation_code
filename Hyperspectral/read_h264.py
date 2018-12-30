import numpy as np
import cv2

cap = cv2.VideoCapture(r'F:\by-device\hyperspectral\Participant \C.h264')
while(1):
    ret, frame = cap.read()
    cv2.imshow('orignal',frame)
    k = cv2.waitKey(1) & 0xff
    if k == 27:
        break
cap.release()
cv2.destroyAllWindows()