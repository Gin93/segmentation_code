path = 'F:\output video jin\thermal1\P10_Interview.mat';


disp('loading......');
video = load (path);
video = video.output_matrix;
disp('loading completed');


result = PlayMatVideo (video, 1 , 2)