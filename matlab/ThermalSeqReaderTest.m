% data_filepath='D:\PhD\PhD Thesis\My Data\Derakhshan\1th Day\aziz mohammmadi\record3_20170221_153212\record3_20170221_153212.seq';


data_filepath ='F:\by-device\thermal\Participant 2\Rec-000019.ats'
% Get seq object for handling frames
[seq,fr,fc] = GetThermalSeqReader(data_filepath);

for fn=1:100
% Get thermal image information
[tSignalImg,tvals]=GetThermalFrame(seq,fn);
if( size(tSignalImg)>1)
    imshow(tSignalImg,[]);
    pause(0.05);
end
end

% Get temperature of point (x=3,y=5) at frame 2
tval=GetThermalValueAt(seq,2,3,5);

toc





    

