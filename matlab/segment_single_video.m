%segment single video
clear all
clc


%% Read csv file, calculate the begining frame and ending frame
%timestamps = csvread ('F:\output video jin\Thermal_cut.csv',3,0);
filename = 'G:\output video jin\Thermal_cut.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;

%% read time stamp

participant_index = 3 ; %%% need change 
ats_index = 'Rec-000022.ats';%%% need change 

ats_file_path =  ['G:\by-device\thermal\Participant ', num2str(participant_index) , '\',ats_index];


s4_start_frame = timestamps(participant_index,1);
s4_end_frame = timestamps(participant_index,2);
s4_start_frame = s4_start_frame - 90;
s4_end_frame = s4_end_frame + 90 ;
s4_start_frame = s4_start_frame - 200;
s4_end_frame = s4_end_frame - 0 ;


s4_start_frame = 3016
s4_end_frame = 3343


total_frame = s4_end_frame - s4_start_frame;

output_matrix = zeros(512,640,total_frame); % the output matrix

%% start to read the .ats file
v = FlirMovieReader(ats_file_path);
v = v.set_unit('temperatureFactory');
frameCount = 0;
disp('cutting......');
while ~isDone(v)
    if mod(frameCount,100) == 0
        disp(frameCount)
    end
    
    
    [frame, metadata] = step(v);
    if frameCount >= s4_start_frame && frameCount <= s4_end_frame
        
        output_matrix(:,:,frameCount-s4_start_frame+1) = frame;
    end
    if frameCount >= s4_end_frame
        break 
    end
    frameCount = frameCount + 1;
end
%output path // May need to change
output_file_name = ['G:\output video jin\thermal2\' ,num2str(participant_index) ,'_.mat'];
save(output_file_name,'output_matrix','-v7.3');

