# -*- coding: utf-8 -*-
"""
Created on Mon Dec 10 14:14:51 2018

@author: u5541673
"""

import os 

input_video_path  = r'F:\output video jin\3\P31-Webcam3-MultiCorder2 - Microsoft® LifeCam Cinema(TM) - 21 December 2017 - 04-18-13 PM - 00000.mp4'
start_time = 775
end_time =  start_time + 90
webcam = 3
participant = 31

#output_path = 'F:\\by-device\\webcam{}\\Participant {}\\'.format(str(webcam),str(participant))
output_path = 'F:\\output video jin\\cut_final_1\\'

#output_video_path = 'F:\\output video jin\\cut_final_1\\{}'.format(str(webcam),str(participant)

output_video_path = 'F:\\output video jin\\cut_final_1\\P31Webcam3.mp4'

cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -i '+ '\"{}\" -ss {} -c copy -to {} \"{}\"'.format(input_video_path ,start_time,end_time, output_video_path)

os.system(cmd)