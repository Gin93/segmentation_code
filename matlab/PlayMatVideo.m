
function human_detector = PlayMatVideo (video, show ,step)
% disp('loading......');
% 
% video = load (path);
% video = video.output_matrix;
% disp('loading completed');

human_detector = [] ;
frames = size (video);
frames = frames (3);
fc = 0 ;
human = 1; % equal 1 by defualt , It will be set to 0 if no one appears in ten consecutive frames


for frame = 1:step:frames % step = 10 
    videoFrameGray = video(:,:,frame);
    
    %     frame1 = im2double(videoFrameGray);
    %      frame2 = imadjust(frame1);
    fc = fc + 1 ;
%     if mode (frame -1 , 10*step)
%         disp(frame)
%     end 
    
    if mod (fc , 5) == 0 % output 1s results 
        human_detector = [human_detector , human];
        human = 1 ;
    end
    if show == 1
        imshow(videoFrameGray,[10,45]);
        pause(0.02);
    end
    
    m = max (max(videoFrameGray));
    if m < 30
        human = 0;
    end
    
end
end





