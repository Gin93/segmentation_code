# -*- coding: utf-8 -*-
"""
Created on Thu Nov 29 12:43:12 2018

@author: u5541673
"""

#from moviepy.editor import VideoFileClip
#clip = VideoFileClip(x)
#clip.duration 


import os 
def all_files(rootDir): 
    o = [] 
    for lists in os.listdir(rootDir): 
        path = os.path.join(rootDir, lists) 
        o.append(path)
        
    return o 
from subprocess import Popen

videos_path = 'F:\\by-device\\' # \ webcam1-4 \ Participant 1-49 \ .mp4
output_txt_path = 'F:\\output video jin\\3\\'
#read all files 
webcams = [2,3,4]
subjects = [x+1 for x in range(49)]
c = 1
for webcam in webcams:
    for subject in subjects:
        video_path = videos_path + 'webcam{}\\Participant {}\\'.format(str(webcam) , str(subject))
        videos = all_files(video_path)
        #output to a txt file
        if videos:
            print(c)
            c += 1
            output_file_name = 'P{}-Webcam{}-{}'.format(str(subject),str(webcam),os.path.basename(videos[0]).split('.')[0])
            output_file_path = output_txt_path + output_file_name + '.txt'
            #save to a txt file 
            
            f = open (output_file_path, 'w')
            for video in videos:
                f.write ('file \'{}\''.format(video))
                f.write('\n')
            f.close()
            #call ffmpeg to merge the video 
            input_txt_path = output_file_path
            output_video_path = output_txt_path + output_file_name + '.mp4'
            
            cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -f concat -safe 0 -i '+ '\"{}\" -c copy \"{}\"'.format(input_txt_path , output_video_path)
#            os.popen (cmd)
            os.system(cmd)
#            Popen(cmd)
        

#        if c == 3:
#            break 
#            print('webcam{}/Participant {}/'.format(str(webcam) , str(subject)))


#ffmpeg.exe -f concat -safe 0 -i "C:\Users\u5541673\Desktop\merge.txt" -c copy output2.mp4
#os.popen (cmd)