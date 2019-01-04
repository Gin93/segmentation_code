%segment single video
clear all
clc


%% Read csv file, calculate the begining frame and ending frame
%timestamps = csvread ('F:\output video jin\Thermal_cut.csv',3,0);
filename = 'f:\output video jin\Thermal_cut.csv';
[A,delimiterOut]=importdata(filename);
timestamps = A.data;

%% read time stamp

participant_index = 35 ; %%% need change
ats_index = 'Rec-000055.ats';%%% need change

ats_file_path =  ['F:\by-device\thermal\Participant ', num2str(participant_index) , '\',ats_index];

start_frame = 18476;
end_frame = 21682;


total_frame = end_frame - start_frame;

% output_matrix = zeros(:,:,total_frame); % the output matrix

%% start to read the .ats file
v = FlirMovieReader(ats_file_path);
v = v.set_unit('temperatureFactory');
frameCount = 1;
disp('cutting......');
skip_frame = 1 ;
while ~isDone(v)
    if mod(frameCount,100) == 0
        disp(frameCount)
    end
    [frame, metadata] = step(v);
        if frameCount >= start_frame && frameCount <= end_frame
            output_matrix(:,:,frameCount-start_frame+1) = frame;
        end
    frameCount = frameCount + 1;
    if frameCount >= end_frame
        break
        
    end
end

% step(v,60000)
% frameCount = frameCount + 60000;
% x_count = 1 ;
% while ~isDone(v)
%     if mod(frameCount,100) == 0
%         disp(frameCount)
%     end
%     [frame, metadata] = step(v);
%     
%     skip_frame = skip_frame + 1 ;
%     if mod(skip_frame , 4) == 0
%         if frameCount >= start_frame && frameCount <= end_frame
%             output_matrix(:,:,x_count) = frame;
%             x_count = x_count + 1 ;
%         end
%     end
%     frameCount = frameCount + 1;
%     if frameCount >= end_frame
%         break
%         
%     end
% end
%output path // May need to change
output_file_name = ['f:\output video jin\thermal2\' , 'P' , num2str(participant_index) ,'_S4 start.mat'];

% output_file_name = ['f:\output video jin\thermal2\' ,'P' , num2str(participant_index) ,'_Interview.mat'];

save(output_file_name,'output_matrix','-v7.3');

