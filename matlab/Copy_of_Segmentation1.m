
% cut the entire interveiw part instead of by question

clear all
clc
path = 'G:\by-device\thermal\';

all_files = dir(path);


% v = FlirMovieReader('F:\by-device\thermal\Participant 2\Rec-000019.ats');
% v = v.set_unit('temperatureFactory');
% [frame, metadata] = step(v,2000);


%% Read csv file, calculate the begining frame and ending frame
filename = 'G:\Segmentation code\segmentation_code\timestamp\segmentatio_thermal_interview.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;
txt_field = A.textdata;
filed_names = txt_field(1,2:end);

%%
for i = 29:length( all_files) % for each participant , from 1-51 , No participant = i - 2
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
0            P = regexp(S(4), ' ', 'split');
            participant_index = str2num(P{1,1}{1,2});
            p_index = ['P', P{1,1}{1,2}];
            %% read timestamps from loaded csv data
            ts = timestamps(participant_index,:);
            atr_names = filed_names;
            if ~ismember (participant_index , [32,33,34,35,36,37,38]) % Need too much RAM
                %% read the .ats file
                v = FlirMovieReader(ats_file_path);
                v = v.set_unit('temperatureFactory');
                frameCount = 0;
                
                %% get inital ts
                [frame, metadata] = step(v);
                initial_frame_count = metadata.FrameNumber;
                fr = metadata.FrameRate;
                
                %% set parameters
                
                ts = [10, ts];
                atr_names = ['trash' , atr_names] ; % period after the end of baseline and before S4 starting
                first_timestamp = 1 ;
                last_timestamp = ts(end);
                if last_timestamp < 0 || isnan(last_timestamp) % invalid data
                    break
                end
                
                cur_ts = 0 ;
                cur_atr = 'baseline';
                f_count = 1 ;
                skip = 0 ;
                has_data_recorded = 0 ; % in case a whole step is lost, that is, check if any data is stored, then output it.
                % to read the first valid timestamp
                while ~isempty(ts)
                    next_ts = ts(1); %read the current ts and attribute, remove them from the list then,
                    next_atr = string(atr_names(1));  % so that, only need to read the first one in the list each time
                    ts(1) = [];
                    atr_names(1) = [] ;
                    if ~isnan (next_ts) && next_ts > 0   % not nan and > 0; means it is valid
                        break
                    else
                        next_ts = ts(1);
                        next_atr = string(atr_names(1));
                        ts(1) = [];
                        atr_names(1) = [] ;
                    end
                end
                
                %% start reading data step by step
                while ~isDone(v)
                    frameCount = frameCount + 1;
                    %                 skip = skip + 1 ;
                    %                 if mod(frameCount,100) == 0
                    %                     disp(frameCount)
                    %                 end
                    
                    
                    %               [frame, metadata] = step(v , skip * 20); % for testing
                    [frame, metadata] = step(v);
                    frame_timestamp = (metadata.FrameNumber - initial_frame_count) * (1/fr);
                    
                    % break if current frame timestamp > step 6 over time; nothing need to read
                    if frame_timestamp > last_timestamp
                        break
                    end
                    % end if cannot find any valid ts
                    if isnan(next_ts) || next_ts < 0
                        break
                    end
                    % less than next_timestamp, save
                    % to save RAM, empty part should not be saved
                    try
                        if  length(strfind(cur_atr , 'S5')) == 0 &&  length(strfind(cur_atr , 'trash')) == 0
                            if (cur_ts <= frame_timestamp) && (frame_timestamp <= next_ts)
                                output_matrix(:,:,f_count) = frame;
                                output_frame_counter(f_count) = metadata.FrameNumber;
                                f_count = f_count + 1 ;
                                has_data_recorded = 1 ;
                            end
                        end
                    catch
                        disp ('error')
                        disp (ats_file_path)
                    end
                    
                    
                    
                    if   frame_timestamp > next_ts % save this, read next VALID one;
                        % if this is the stage before step 4, skip save
                        
                        
                        output_file_name = join([p_index ,'_' , cur_atr],'');
                        output_file_name_fc = join([p_index,'_',cur_atr,'_framecounter'],'');
                        output_path = join(['G:\output video jin\thermal2\' , output_file_name],'');
                        output_path_fc = join(['G:\output video jin\thermal2\' , output_file_name_fc],'');
                        
                        if  length(strfind(cur_atr , 'S5')) == 0 &&  length(strfind(cur_atr , 'trash')) == 0
                            if has_data_recorded == 1
                                disp (output_file_name);
                                disp (output_file_name_fc);
                                disp((metadata.FrameNumber - initial_frame_count) * (1/fr)); % timestamp
                                save(output_path,'output_matrix','-v7.3'); % do not save step 5 and the period between end of baseline and start of S4
                                save(output_path_fc,'output_frame_counter','-v7.3');
                            end
                        end
                        
                        clear output_matrix % reset
                        clear output_frame_counter
                        clear output_file_name
                        clear output_file_name_fc
                        f_count = 1 ;
                        has_data_recorded = 0;
                        
                        % read next timestamp
                        cur_ts = next_ts;
                        cur_atr = next_atr ;
                        
                        
                        % end if no more 'next timestamp'
                        if isempty(ts)
                            break
                        end
                        
                        while ~isempty(ts)
                            next_ts = ts(1);
                            next_atr = string(atr_names(1));
                            ts(1) = [];
                            atr_names(1) = [] ;
                            if ~isnan (next_ts) && cur_ts > 0 % not nan and > 0; means it is valid
                                break
                            else
                                next_ts = ts(1);
                                next_atr = string(atr_names(1));
                                ts(1) = [];
                                atr_names(1) = [] ;
                            end
                        end
                    end
                end
            end
        end
    end
end