
clear all
clc
path = 'F:\by-device\thermal\';

all_files = dir(path);


v = FlirMovieReader('F:\by-device\thermal\Participant 2\Rec-000019.ats');
v = v.set_unit('temperatureFactory');
[frame, metadata] = step(v);

%% Read csv file, calculate the begining frame and ending frame
%timestamps = csvread ('F:\output video jin\Thermal_cut.csv',3,0);
filename = 'F:\output video jin\Thermal_cut.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;


%%

for i = 1:length( all_files) % for each participant , from 1-51 , No participant = i - 2
    %     all_files(i).name
    
    repo_path = [path , all_files(i).name ];
    all_videos = dir (repo_path); % contain . , .. and maybe more than one .ats files and even .wmv file
    len = length(all_videos);
    
    for j = 1:length(all_videos)
        file_name = all_videos(j).name; % 'Rec-000028.ats'
        if length(strfind(file_name , '.ats')) == 1 % the file_name is a .ats file
            
            repo_path = [repo_path , '\' ]; % 'F:\by-device\thermal\Participant 9\'
            ats_file_path = [repo_path , file_name]; %  'F:\by-device\thermal\Participant 9\Rec-000028.ats'
            %% prepare, read timestamp data, create empty output matrix
            S = regexp(repo_path, '\', 'split');% Read participant index
            P = regexp(S(4), ' ', 'split');
            participant_index = str2num(P{1,1}{1,2});
            s4_start_frame = timestamps(participant_index,1);
            s4_end_frame = timestamps(participant_index,2);
            if s4_start_frame <= 0 || s4_end_frame <= 0 || isnan(s4_start_frame) || isnan(s4_end_frame)
                break %validation, break if the data is invalid
            end
            s4_start_frame = s4_start_frame - 90;
            s4_end_frame = s4_end_frame + 90 ;
            total_frame = s4_end_frame - s4_start_frame;
            output_matrix = zeros(512,640,total_frame); % the output matrix
            %% start to read the .ats file
            v = FlirMovieReader(ats_file_path);
            v = v.set_unit('temperatureFactory');
            frameCount = 0;
            while ~isDone(v)
                if mod(frameCount,100) == 0
                    disp(frameCount)
                end
                
                [frame, metadata] = step(v);
                %                 m = max (max (frame)) ;
                %                 if m > 33
                %                     disp(frameCount)
                %                 end
                if frameCount >= s4_start_frame && frameCount <= s4_end_frame
                    output_matrix(:,:,frameCount-s4_start_frame+1) = frame;
                end
                
                frameCount = frameCount + 1;
            end
            %output path // May need to change 
            output_file_name = ['F:\output video jin\thermal2\' ,num2str(participant_index) ,'.mat'];
            save(output_file_name,'output_matrix','-v7.3');
        end
    end
end
