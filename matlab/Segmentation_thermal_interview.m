
% cut the entire interveiw part instead of by question

clear all
clc
path = 'F:\by-device\thermal\';

all_files = dir(path);


% v = FlirMovieReader('F:\by-device\thermal\Participant 2\Rec-000019.ats');
% v = v.set_unit('temperatureFactory');
% [frame, metadata] = step(v,2000);


%% Read csv file, calculate the begining frame and ending frame
filename = 'F:\Segmentation code\segmentation_code\timestamp\segmentatio_thermal_interview.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;
txt_field = A.textdata;
filed_names = txt_field(1,2:end);

%%
for i = 4:length( all_files) % for each participant , from 1-51 , No participant = i - 2
    %     all_files(i).name
    
    repo_path = [path , all_files(i).name ];
    all_videos = dir (repo_path); % contain . , .. and maybe more than one .ats files and even .wmv file
    len = length(all_videos);
    
    for j = 1:length(all_videos)
        file_name = all_videos(j).name; % 'Rec-000028.ats'
        if length(strfind(file_name , '.ats')) == 1 % the file_name is a .ats file
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
            ts = timestamps(participant_index,:);
            atr_names = filed_names;
            if ismember (participant_index , [32,33,34,35,36,37,38]) % Need too much RAM
%              if ismember (participant_index , [31]) % Need too much RAM   
                %% read the .ats file
                v = FlirMovieReader(ats_file_path);
                v = v.set_unit('temperatureFactory');
                frameCount = 0;
                
                %% get inital ts
                [frame, metadata] = step(v);
                initial_frame_count = metadata.FrameNumber;
                fr = metadata.FrameRate;
                %% check ts
                if any(isnan(ts)) % contain NAN, break!
                    disp (ats_file_path)
                    break %validation, break if the data is invalid
                    
                end
                disp(ts)
                if any(ts <= 0 ) % contain 0, (also invalid)
                    disp (ats_file_path)
                    break
                end

                cur_ts = ts(1);
                cur_atr = string(atr_names(1));
                ts(1) = [];
                atr_names(1) = [] ;
                next_ts = ts(1); % in here, all ts is valid
                next_atr = string(atr_names(1));
                has_data_recorded = 0 ; % in case a whole step is lost, that is, check if any data is stored, then output it.
                f_count = 1 ;
                x_count = 1 ;
                %% start reading data step by step
                skip = cur_ts * 120;
                step(v,skip) ; 
                while ~isDone(v)
                    %                 skip = skip + 1 ;
                                    if mod(f_count,500) == 0
                                        disp(f_count)
                                    end                
                    %               [frame, metadata] = step(v , skip * 20); % for testing
                    [frame, metadata] = step(v);
                    frame_timestamp = (metadata.FrameNumber - initial_frame_count) * (1/fr);                 
                    
                    
                    % less than next_timestamp, save
                    % to save RAM, empty part should not be saved
%                     try               

%                         if (cur_ts <= frame_timestamp) && (frame_timestamp <= next_ts)
%                             output_matrix(:,:,f_count) = frame;
%                             output_frame_counter(f_count) = metadata.FrameNumber;
%                             f_count = f_count + 1 ;
%                             has_data_recorded = 1 ;
%                         end

                    if mod(f_count , 4) == 0 % record 1 frame for every 4 frames 
                           if (cur_ts <= frame_timestamp) && (frame_timestamp <= next_ts)
                            output_matrix(:,:,x_count) = frame;
                            output_frame_counter(x_count) = metadata.FrameNumber;
                            has_data_recorded = 1 ;
                            x_count = x_count +  1 ;
                           end   
                    end
                    f_count = f_count + 1 ;
                    

              
                    if   frame_timestamp > next_ts % save this, break, since only two ts, no next one
                        
                        output_file_name = join([p_index ,'_' , cur_atr],'');
                        output_file_name_fc = join([p_index,'_',cur_atr,'_framecounter'],'');
                        output_path = join(['F:\output video jin\thermal1\' , output_file_name],'');
                        output_path_fc = join(['F:\output video jin\thermal1\' , output_file_name_fc],'');
                        
                        
                        if has_data_recorded == 1
                            disp (output_file_name);
                            disp (output_file_name_fc);
                            disp((metadata.FrameNumber - initial_frame_count) * (1/fr)); % timestamp
                            save(output_path,'output_matrix','-v7.3'); % do not save step 5 and the period between end of baseline and start of S4
                            save(output_path_fc,'output_frame_counter','-v7.3');
                        end
                        
                        
                        clear output_matrix % reset
                        clear output_frame_counter
                        clear output_file_name
                        clear output_file_name_fc
                        f_count = 1 ;   
                        break % this subject's data segmentation is over 
                    end
                end
            end
        end
    end
end
