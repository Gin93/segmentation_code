
clear all
clc
path = 'F:\by-device\thermal\';

all_files = dir(path);


%%

for i = 3:length(all_files) % for each participant , from 1-51 , No participant = i - 2
    %     all_files(i).name
    
    repo_path = [path , all_files(i).name ];
    all_videos = dir (repo_path); % contain . , .. and maybe more than one .ats files and even .wmv file
    len = length(all_videos);
    file_count = 0 ;
    for j = 1:length(all_videos)
        file_name = all_videos(j).name; % 'Rec-000028.ats'
        if length(strfind(file_name , '.ats')) == 1 % the file_name is a .ats file
            
            repo_path = [repo_path , '\' ] % 'F:\by-device\thermal\Participant 9\'
            ats_file_path = [repo_path , file_name]; %  'F:\by-device\thermal\Participant 9\Rec-000028.ats'
            %% prepare, read timestamp data, create empty output matrix
            S = regexp(repo_path, '\', 'split');% Read participant index
            P = regexp(S(4), ' ', 'split');
            participant_index = str2num(P{1,1}{1,2}); % get participant index
            p_index = ['P', P{1,1}{1,2}];
            
            file_count = file_count + 1 ;
            disp (file_count)
            %% for testing 
%             p_index = 'P20' ;
%             ats_file_path = 'F:\by-device\thermal\Participant 20\Rec-000040.ats' ;
%             
            
            %% start to read the .ats file
            disp (ats_file_path)
            v = FlirMovieReader(ats_file_path);
            v = v.set_unit('temperatureFactory');
            
            frameCount = 0;
            clips_count = 1;
            human_frames_count = 0 ;
            clip_begin = 0;
            
            while ~isDone(v)
                frameCount = frameCount + 1;
                
                if mod(frameCount,2000) == 0
                    disp(frameCount)
                end
                
                [frame, metadata] = step(v);
                
                if mod(frameCount,10) == 0
%                     m = max (max (frame)) ;
%                     if m > 30
                        
                    m = sum(sum(frame > 30)); % the amount of pixels which temp > 30 
                    if m > 16000 % estimated front face size 19000
                        if human_frames_count == 0 % this is the first frame detect human
                            clip_begin = frameCount;
                        end
                        
                        human_frames_count = human_frames_count + 1 ; % got a frame that contain human. 
                        
                    else
                        if human_frames_count > 18 % it could be the clip we want. 6s ->  6* 30 /10 = 18
                            
                            clip_end = frameCount ;% store this period
                            all_out_data(clips_count).(p_index) = [clip_begin - 5 , clip_end];
                            
                            clips_count  = clips_count + 1 ;
                            
                            human_frames_count = 0 ;
                            clip_begin = 0;
                            
                        else % some flash, reset all parameters 
                            human_frames_count = 0 ;
                            clip_begin = 0;                           
                            
                        end
                    end
                end
            end
        save(p_index,'all_out_data','-v7.3');
        end
    end 
end
        
