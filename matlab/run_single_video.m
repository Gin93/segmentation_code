path = 'F:\output video jin\thermal3\P16_S4 start.mat';


disp('loading......');
video = load (path);
video = video.output_matrix;
disp('loading completed');


result = PlayMatVideo (video, 1 , 2)