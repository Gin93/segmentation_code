import os 
def get_all_files(rootDir,extended): 
    o = [] 
    for lists in os.listdir(rootDir): 
        path = os.path.join(rootDir, lists) 
        if '.' not in path: # indiect this is a repo instead of a file 
            x = get_all_files(path,extended)
            if extended:
                for i in x:
                    o.append(i)
            else:
                o.append(x)
        else:
            o.append(path)
        
    return o 
    
    
#%% delete files 

#%% move files 

#%% move webcam 

#%% move thermal data 

#%% move eopc data 

#%% check E4 data

repo_path = r'F:\by-device\empatica'

all_files = get_all_files(repo_path , 1 )

trash_list = [] 

#empty_stages = ['S5 starts' , 'S4 starts' , 'S3 starts']# s5 end contains the baseline data, s6 starts is the interview part 
#for file in all_files:
#    fsize = os.path.getsize(file)
#    for stage in empty_stages:
#        if stage in file:
#            trash_list.append(file)


for file in all_files:
    fsize = os.path.getsize(file)
    if fsize == 0:
        trash_list.append(file)



#%% remove the empty files in F:\by-device\myo\Participant {xx}\

#repo_path = r'F:\by-device\myo'
#
#all_files = get_all_files(repo_path , 1 )
#
#trash_list = [] 
#
#empty_stages = ['S5 starts' , 'S4 starts' , 'S3 starts']# s5 end contains the baseline data, s6 starts is the interview part 
#for file in all_files:
#    fsize = os.path.getsize(file)
#    for stage in empty_stages:
#        if stage in file:
#            trash_list.append(file)
#
#
#for file in all_files:
#    fsize = os.path.getsize(file)
#    if fsize == 0 and 'Q1' in file:
#        trash_list.append(file)



#for trash in trash_list:
#    os.remove(trash)

