% fname = 'F:\by-device\epoc\Participant 2\p02.md.edf'
% 
% [hdr, record] = edfread(fname) ;


ats_file_path = 'F:\by-device\thermal\Participant 33\Rec-000053.ats';

v = FlirMovieReader(ats_file_path);

 while ~isDone(v)
     [x,y] = step (v);
%      disp (y.FrameRate)
     disp (y.FrameCounter)
 end 