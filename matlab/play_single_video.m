path = 'F:\output video jin\thermal1\P35_Interview.mat';

path = 'F:\output video jin\thermal2\P35_S4 start.mat';
% path = 'F:\output video jin\thermal3\P31_S4 start.mat';
disp('loading......');
video = load (path);
video = video.output_matrix;
disp('loading completed');


result = PlayMatVideo (video, 1 , 2)