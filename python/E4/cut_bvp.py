# -*- coding: utf-8 -*-
"""
Created on Wed Dec 12 11:06:49 2018

@author: u5541673
"""



#read timestamps stored in csv file 

import time 
import csv
from time import localtime as tt 

from .fs import * 

def s_to_date (ts):
    h = int (ts / 3600)
    m = int (( ts %3600) / 60) 
    s = ts % 60
    return (h,m,s)



if __name__ == '__main__':
    subjects = [x+1 for x in range(49)]
#    subjects = [x+1 for x in range(10)]
#    subjects = [10]
    all_participants_data = {}
    time_file = r'F:\Segmentation code\segmentation_code\timestamp.csv'
    all_timestamps = read_timestamp_file(time_file) # read timestamps.

    for subject in subjects:
        ### get the bvp file path
        e4_path = 'F:\\by-device\\empatica\\'
        e4_path = e4_path + '\\Participant {}\\'.format(str(subject)) # eg: F:\\by-device\\empatica\\Participant 2\\
        if subject >= 2 and subject <= 5: # read the p2 repo data, but it should belong to p1 actually 
            subject -= 1 
        
        files = all_files(e4_path , 1 )
        bvp_file_path = ''
        for file in files:
            if 'BVP' in file:
                bvp_file_path = file 

        ### read the bvp file data 
        with open (bvp_file_path) as f:
            f_csv = csv.reader(f)
            timestamp = int(float(next(f_csv)[0]))
            t = time.localtime(timestamp)
            timestamp_initial = t[3] * 3600 + t[4] *60 + t[5] # care the summer time issue
            hz = int(float(next(f_csv)[0]))
            all_data = [i[0] for i in f_csv]
            
        ## prepare for segmenting the data 
        timestamps = all_timestamps[str(subject)]
        timestamps_each_step = [[timestamps[i] , i] for i in timestamps if timestamps[i] != 'invalid' and timestamps[i]] # filter the 'invalid' and lost data
        timestamps_each_step = [i for i in timestamps_each_step ]
        timestamps_each_step.sort() # add baseline timestamp HERE 
        bl_time = 40 # set up 40s as the baseline collection period  
        bl = [timestamps_each_step[0][0] - bl_time,'baseline data'] #
        timestamps_each_step.insert(0 , bl)
#            print(timestamps_each_step)
        output_data = { }
        tem_data = []
        for  index , data in enumerate(all_data):
            ts = timestamp_initial + (1 / hz * index) 
            first_time  = timestamps_each_step[0][0]
            if ts < first_time:
                continue 
            else: # start to record 
                if len (timestamps_each_step) > 1:
                    
                    if ts < timestamps_each_step[1][0]: # less than next stage timestamp, so store the data into cur_state 
                        tem_data.append([float(data) , ts]) 
                        
                    else:
#                        print(tem_data)
                        output_data [timestamps_each_step[0][1]] =  tem_data # great than next stage timestamp, save the data, load next state
                        timestamps_each_step.pop(0)
                        tem_data = []
                        
#        print(len(all_data) / hz)
#        if len(all_data) > 1:
#            first_ts = timestamp_initial 
#            last_ts =  int (timestamp_initial + len(all_data) / hz) 
#            output_data['ts'] = ( s_to_date(first_ts) , s_to_date (last_ts) )
#        else:
#            print(data_type , subject )
            
        all_participants_data[subject] = output_data
        
    # save the data into csv file 

    for subject in all_participants_data:
        output_path = 'F:\\by-device\\empatica\\Participant {}\\'.format(str(subject))
        for each_step in all_participants_data[subject]:
            output_file_name = output_path + each_step + '.csv'
            with open (output_file_name,'w',newline = '') as f :
                writer = csv.writer(f)
                for row_data in all_participants_data[subject][each_step]:
                    writer.writerow(row_data)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        