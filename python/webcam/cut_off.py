# -*- coding: utf-8 -*-
"""
Created on Fri Nov 30 14:35:34 2018

@author: u5541673
"""


# read the csv file , get begining timestamp 

# call cmd to cutoff the video 

import os 
def all_files(rootDir): 
    o = {}
    for lists in os.listdir(rootDir): 
        path = os.path.join(rootDir, lists) 
        o.append(path)
        
    return o 
from subprocess import Popen

from moviepy.editor import VideoFileClip


time_file = r'F:\Segmentation code\segmentation_code\timestamp\timestamp.csv'
videos_path = 'F:\\output video jin\\3\\'
output_path = 'F:\\output video jin\\cut_final_1\\'
example = 'F:\by-device\webcam1\Participant 6'


participants = {}
import csv
with open(time_file) as f:
    f_csv = csv.DictReader(f)
    for row in f_csv:
        if row['S5 starts'] and row['S5 starts'] != 'invalid':
            subject = row[''].split('pant')[1]
            start_time = row['S5 starts'] # real-time , need to read the file name then calculate the relavent time 
            h , m , s = start_time.split(':')
            delay = 0 # need few seconds to walk to the stairs 
            start_time = int(h) * 3600 + int(m) * 60 + int(s) + delay 
            end_time = start_time + 50 # not used 
            participants[subject] = (start_time , end_time)
            


webcams = [1,2,3,4]

video_miss_list = [] # have record, but no video 


all_videos = {}
for video in os.listdir(videos_path):
    path = os.path.join(videos_path, video) 
    p , web , a1 ,a2 ,a3 , h , m , s_half_day_shift, index = video.split('-')
    s , shift, empty =  s_half_day_shift.split(' ')
    start_time = int (h) * 3600 + int(m) * 60 + int(s)
    if shift == 'PM' and h != ' 12':
        start_time += 3600 * 12
    index = int (index.split('.')[0])
    start_time = start_time + 5*60*index
    video_name = p + web 
    all_videos [video_name] = (path , start_time,a3)


wrong_list = [] 
c = len(all_videos) 
for participant in participants:
    for webcam in webcams:
        file_name = 'P{}Webcam{}'.format(participant, str(webcam))
        if file_name in all_videos:
            start_time,end_time = participants[participant]
            input_video_path = all_videos[file_name][0] # should find another method to locate the input_video_path 
            start_time_relative = start_time - all_videos[file_name][1] # the relative time stamp 
            actual_date =  all_videos[file_name][2]
            if start_time_relative < -70: # wrong p index 
                wrong_list.append([file_name , start_time_relative])
                continue # pass this video 
            
            else:
                start_time = start_time_relative 
                
                
            
            end_time = start_time + 90 # define the end time here 
#            output_path = 'F:\\by-device\\webcam{}\\Participant {}\\'.format(webcam,participant)

            

            output_video_path = output_path + file_name + '.mp4'
            print (c - len(all_videos) ) 
            print (output_video_path)
            cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -i '+ '\"{}\" -ss {} -c copy -to {} \"{}\"'.format(input_video_path ,start_time,end_time, output_video_path)
            
            
            os.system(cmd)
            

            del all_videos[file_name]
        else:# video miss, record
            video_miss_list.append(file_name)

for i in wrong_list :
    print(i)


#print (all_videos)
wrong_list = [] 
c = len(all_videos) 
p = ['20','19']
for participant in participants: # read from csv 
    if participant not in p:
        for webcam in webcams:
            file_name = 'P{}Webcam{}'.format(participant, str(webcam))
            if file_name in all_videos:
                start_time,end_time = participants[participant]
                input_video_path = all_videos[file_name][0] # should find another method to locate the input_video_path 
                start_time_relative = start_time - all_videos[file_name][1] # the relative time stamp 
                actual_date =  all_videos[file_name][2]
                if start_time_relative < -70: # wrong p index 
                    for i in all_videos:
                        this_video_subject = int (i.split('Webcam')[1])
                        if webcam == this_video_subject: # make sure the webcam index is same 
                        
                            this_video_path , this_video_time , date = all_videos[i]
                            if actual_date == date: # in case, same time but different date 
                            
                                clip = VideoFileClip(this_video_path)
                                duration = clip.duration
                                clip.close()
                                if start_time > this_video_time and start_time < this_video_time + duration: # means this is the correct one 
                                    file_name = i  # re-define the file_name , path and start time 
                                    input_video_path = this_video_path
                                    start_time = start_time - this_video_time
                                    print(participant , i )
                    wrong_list.append([participant , i , file_name , start_time])
                
                else:
                    start_time = start_time_relative
                    
                    
                
                end_time = start_time + 90 # define the end time here 
    #            output_path = 'F:\\by-device\\webcam{}\\Participant {}\\'.format(webcam,participant)
    
                
    
                output_video_path = output_path + file_name + '.mp4'
    
    
                cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -i '+ '\"{}\" -ss {} -c copy -to {} \"{}\"'.format(input_video_path ,start_time,end_time, output_video_path)
                
                print (len(all_videos) - c) 
                os.system(cmd)
                
                
                    
                    
                del all_videos[file_name]
            else:# video miss, record
                video_miss_list.append(file_name)
            
            
#wrong_list = [] 
#c = len(all_videos) 
#for participant in participants:
#    for webcam in webcams:
#        file_name = 'P{}Webcam{}'.format(participant, str(webcam))
#        if file_name in all_videos:
#            start_time,end_time = participants[participant]
#            input_video_path = all_videos[file_name][0] # should find another method to locate the input_video_path 
#            start_time_relative = start_time - all_videos[file_name][1] # the relative time stamp 
#            actual_date =  all_videos[file_name][2]
#            if start_time_relative < 0: # wrong p index 
#                for i in all_videos:
#                    this_video_subject = int (i.split('Webcam')[1])
#                    if webcam == this_video_subject: # make sure the webcam index is same 
#                    
#                        this_video_path , this_video_time , date = all_videos[i]
#                        if actual_date == date: # in case, same time but different date 
#                        
#                            clip = VideoFileClip(this_video_path)
#                            duration = clip.duration
#                            clip.close()
#                            if start_time > this_video_time and start_time < this_video_time + duration: # means this is the correct one 
#                                file_name = i  # re-define the file_name , path and start time 
#                                input_video_path = this_video_path
#                                start_time = start_time - this_video_time
#                                print(participant , i )
#                                break 
#            
#            else:
#                start_time = start_time_relative
#                
#                
#            
#            end_time = start_time + 90 # define the end time here 
#            output_path = 'F:\\by-device\\webcam{}\\Participant {}\\'.format(webcam,participant)
#
#            
#
#            output_video_path = output_path + file_name + '.mp4'
#
#
##            cmd = r'C:\Users\u5541673\Desktop\ffmpeg-20181122-ce0a753-win64-static\bin\ffmpeg.exe -i '+ '\"{}\" -ss {} -c copy -to {} \"{}\"'.format(input_video_path ,start_time,end_time, output_video_path)
#            
##            print (len(all_videos) - c) 
##            os.system(cmd)
#            
#            
##            if participant == '19' and webcam == 2:
##                print(participants[participant])
##                print(start_time , end_time)
##                print(cmd)
#                
#                
#            del all_videos[file_name]
#        else:# video miss, record
#            video_miss_list.append(file_name)



#print(video_miss_list) # miss 
#print(all_videos) # have video, but no records to cutoff them 


'''
ffmpeg -i input.wmv -ss 30 -c copy -to 40 output.wmv
'''


