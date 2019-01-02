
clear all
clc

path = 'G:\by-device\epoc\Participant 12\p12.edf';

[hdr, record] = edfread(path);


filename = 'G:\Segmentation code\segmentation_code\timestamp\segmentation_epoc.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;

path = 'G:\by-device\epoc\';

all_files = dir(path);

for i = 3:length( all_files) % for each participant , from 1-51 , No participant = i - 2
    %     all_files(i).name
    
    repo_path = [path , all_files(i).name ];
    all_videos = dir (repo_path); % contain . , .. and maybe more than one .ats files and even .wmv file
    len = length(all_videos);
    if len > 2 % has at least one data file
        
        
        for j = 3:length(all_videos)
            file_name = all_videos(j).name; % 'p11.edf'
            
            %% get the data file type
            if length(strfind(file_name , '.md')) == 1 % the file_name is a edf file with md in file name
                file_type = 'md'; % differentiate output file names
                fps = 64;
                timestamps_ = timestamps(:,3:4);
            else
                file_type = '';
                fps = 128;
                timestamps_ = timestamps(:,1:2);
            end
            
            %% prepare, read timestamp data, create empty output matrix
            repo_path = [repo_path , '\' ]; % 'F:\by-device\thermal\Participant 9\'
            ats_file_path = [repo_path , file_name]; %  'F:\by-device\thermal\Participant 9\Rec-000028.ats'
            disp(ats_file_path)
            
            %% get participant index via repo name
            S = regexp(repo_path, '\', 'split');% Read participant index
            P = regexp(S(4), ' ', 'split');
            participant_index = str2num(P{1,1}{1,2});
            p_index = ['P', P{1,1}{1,2}];
            
            %% read timestamps from loaded csv data
            
            start_frame = timestamps_(participant_index,1);
            end_frame = timestamps_(participant_index,2);
            if start_frame <= 0 || end_frame <= 0 || isnan(start_frame) || isnan(end_frame)
                break %validation, break if the data is invalid
            end
            
            %% start to read the .edf file
            [hdr, record] = edfread(ats_file_path);
            %             start_time = hdr.starttime;
            fps = hdr.frequency;
            if end_frame > length (record) % means cannot segment the data, 
                disp (join(['error:' , ats_file_path , '     ', num2str(end_frame), '   /  ' num2str(length(record))] ))

            else 
            output.data = record (:,start_frame:end_frame); % segment the data
            output.hdr = hdr;
            output_file_name = join([p_index,'_',file_type],''); % output file name
            output_path = join(['G:\output video jin\epoc\' , output_file_name],''); % output file path
            save(output_path,'output','-v7.3');
            end 
            
        end
    end
end
