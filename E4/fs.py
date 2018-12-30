# -*- coding: utf-8 -*-
"""
Created on Wed Dec 12 18:48:15 2018

@author: u5541673
"""

import time 
import os 
import csv



def all_files(rootDir,extended): 
    o = [] 
    for lists in os.listdir(rootDir): 
        path = os.path.join(rootDir, lists) 
        if '.' not in path: # indiect this is a repo instead of a file 
            x = all_files(path,extended)
            if extended:
                for i in x:
                    o.append(i)
            else:
                o.append(x)
        else:
            o.append(path)
        
    return o 
    
    
def read_timestamp_file ():
    time_file = 'F:\\output video jin\\timestamp.csv'
    participants = {}
    
    with open(time_file) as f:
        f_csv = csv.DictReader(f)
        for row in f_csv:
    #        if row['S5 starts'] and row['S5 starts'] != 'invalid':
            subject = row[''].split('pant')[1]
            each_step_timestamp = {}
            for step in row:
                if step: # skip the first col, which is ''
                    timestamp = row[step] # real-time , need to read the file name then calculate the relavent time 
                    if timestamp and timestamp != 'invalid':
                        h , m , s = timestamp.split(':')
                        start_time = int(h) * 3600 + int(m) * 60 + int(s)
                        each_step_timestamp [step] = start_time
                    else:
                        each_step_timestamp [step] = 'invalid'
                    participants[subject] = each_step_timestamp
                step = {}
    return participants 