# -*- coding: utf-8 -*-
"""
Created on Mon Dec 10 14:14:51 2018

@author: u5541673
"""

import os 

input_video_path  = r'F:\output video jin\3\P18-Webcam3-MultiCorder2 - Microsoft® LifeCam Cinema(TM) - 21 December 2017 - 10-51-31 AM - 00002.mp4'
start_time = 650
end_time =  start_time + 120
webcam = 3
participant = 18

#output_path = 'F:\\by-device\\webcam{}\\Participant {}\\'.format(str(webcam),str(participant))
output_path = 'F:\\output video jin\\cut_final_1\\'

#output_video_path = 'F:\\output video jin\\cut_final_1\\{}'.format(str(webcam),str(participant)

output_video_path = 'F:\\output video jin\\cut_final_1\\P18Webcam3.mp4'

cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -i '+ '\"{}\" -ss {} -c copy -to {} \"{}\"'.format(input_video_path ,start_time,end_time, output_video_path)

os.system(cmd)