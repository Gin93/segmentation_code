
def convert_16_bits_unix_ts(ts):
    ts_s = ts[:-6]
    ts_us = ts[-6:]
    timestamp = int(ts_s)
    t = time.localtime(timestamp)
    # be careful with the summer time issue    
    ts_second = t[3] * 3600 + t[4] *60 + t[5]
    ts_second += float(ts_us) / 1000 / 1000
    return ts_second

def convert_16_bits_unix_date(ts):
    ts_s = ts[:-6]
    ts_us = ts[-6:]
    timestamp = int(ts_s)
    t = time.localtime(timestamp)
    # be careful with the summer time issue  
    return (t[3] , t[4] , t[5])



import time 
import csv
import sys , os 
sys.path.append(os.path.abspath('..'))
from functions.fs import *


#'1513746299273630'
#
#1513746299


if __name__ == '__main__':
    subjects = [x+1 for x in range(49)]
#    subjects = [x+1 for x in range(10)]
    
    time_file = r'F:\Segmentation code\segmentation_code\timestamp\timestamp_byquestion.csv'
    all_timestamps = read_timestamp_file(time_file)    
    all_types_data = {}
    data_types = ['accelerometer' , 'emg' , 'gyro' , 'orientation' , 'orientationEuler']
    subjects = [31]
#    data_types = ['accelerometer']
    for data_type in data_types:
        all_participants_data = {}
        for subject in subjects:
            ### get the bvp file path
            myo = 'F:\\by-device\\myo\\'
            file_path = myo + '\\Participant {}\\'.format(str(subject)) # eg: F:\\by-device\\empatica\\Participant 2\\
            files = all_files(file_path , 1 )
            data_files_path = []
            for file in files:
                if data_type == 'orientation':
                    if 'orientation' in file and '_' not in file and 'orientationEuler' not in file: # orientation IS PART OF orientationEuler!!!!!!!!
                        data_files_path.append(file) # more than one file 
                    
                else:
                    if data_type in file and '_' not in file: # exclude the segmented files 
                        data_files_path.append(file) # more than one file 

            ### read data, may need merge them firstly 
            all_data = [] 
            data_files_path.sort() # make sure read in chronological order 
            for data_file_path in data_files_path:                
                with open (data_file_path) as f:
                    f_csv = csv.reader(f)
                    next(f_csv)# skip first line 
                    for row_data in f_csv:
                        all_data.append(row_data)

                    
            ## prepare for segmenting the data 
            timestamps = all_timestamps[str(subject)]
            timestamps_each_step = [[timestamps[i] , i] for i in timestamps if timestamps[i] != 'invalid' and timestamps[i]] # filter the 'invalid' and lost data
            timestamps_each_step = [i for i in timestamps_each_step ]
            timestamps_each_step.sort() #no baseline data, since the s5 ends part can be treated as the baseline data 
    #            print(timestamps_each_step)
            output_data = { }
            tem_data = []
            for  data in all_data :
                ts = data[0]
                
                ts = convert_16_bits_unix_ts(ts)
                first_time  = timestamps_each_step[0][0]
                if ts < first_time:
                    continue 
                else: # start to record 
                    if len (timestamps_each_step) > 1:                     
                        if ts < timestamps_each_step[1][0]: # less than next stage timestamp, so store the data into cur_state 
                            tem_data.append(data)                                    
                        else:
                            output_data [timestamps_each_step[0][1]] =  tem_data # great than next stage timestamp, save the data, load next state
                            timestamps_each_step.pop(0)
                            tem_data = []
            
#            if len(all_data) > 1:
#                first_ts = all_data[0] 
#                last_ts = all_data[-1]
#                output_data['ts'] = (convert_16_bits_unix_date (first_ts[0]) , convert_16_bits_unix_date(last_ts[0]))
#            else:
#                print(data_type , subject )
   
            all_participants_data[subject] = output_data
        all_types_data[data_type] = all_participants_data

    #        print(output_data)
                    
                
    for data_type in data_types:
        for subject in all_participants_data:
            output_path = 'F:\\by-device\\myo\\Participant {}\\'.format(str(subject))
            for each_step in all_participants_data[subject]:
                output_file_name = output_path + data_type + '_' + each_step + '.csv'
                with open (output_file_name,'w',newline = '') as f :
                    writer = csv.writer(f)
                    for row_data in all_participants_data[subject][each_step]:
                        writer.writerow(row_data)
 
        
        
        
        
        
        
        
        