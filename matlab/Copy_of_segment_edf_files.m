% cut edf data by quesiton

clear all
clc

path = 'G:\by-device\epoc\Participant 12\p12.edf';

[hdr, record] = edfread(path);



%% Read csv file, calculate the begining frame and ending frame
filename = 'G:\Segmentation code\segmentation_code\timestamp\segmentation_epoc_question.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;
txt_field = A.textdata;
filed_names = txt_field(1,2:end);


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
            else
                file_type = '';
            end
            
            %% prepare, read timestamp data, create empty output matrix
            repo_path = [repo_path , '\' ]; % 'F:\by-device\thermal\Participant 9\'
            ats_file_path = [repo_path , file_name]; %  'F:\by-device\thermal\Participant 9\Rec-000028.ats'
            %             disp(ats_file_path)
            
            %% get participant index via repo name
            S = regexp(repo_path, '\', 'split');% Read participant index
            P = regexp(S(4), ' ', 'split');
            participant_index = str2num(P{1,1}{1,2});
            p_index = ['P', P{1,1}{1,2}];
            
            atr_names = filed_names;
            
            
            %% read timestamps from loaded csv data
            [hdr, record] = edfread(ats_file_path);
            fps = hdr.frequency(1);               
            ts = timestamps(participant_index,:);
            ts = ts * fps;
            if any(isnan(ts)) % contain NAN, break!
                disp (ats_file_path)
                break %validation, break if the data is invalid
                
            end
            disp(ts)
            if any(ts == 0) % contain 0, (also invalid)
                disp (ats_file_path)
                break
            end
            if ts(end) >  length (record)
                
                disp (join(['error:' , ats_file_path , '     ', num2str(ts(end)), '   /  ' num2str(length(record))] ))
                break
            end            
            %% start to read the .edf file
 
            cur_ts = ts(1);
            cur_atr = string(atr_names(1));
            ts(1) = [];
            atr_names(1) = [] ;
            while ~isempty(ts)
                next_ts = ts(1);
                next_atr = string(atr_names(1));
                ts(1) = [];
                atr_names(1) = [] ;
                output.data.(cur_atr) = record (:,cur_ts:next_ts);
                cur_ts = next_ts;
                cur_atr = next_atr;
                
            end            
            output.hdr = hdr;
            output.raw_file_name = file_name;
            output_file_name = join([p_index,'_',file_type,'_byquestion'],''); % output file name
            output_path = join(['G:\output video jin\epoc\' , output_file_name],''); % output file path
            save(output_path,'output','-v7.3');
        end
        
    end
end

