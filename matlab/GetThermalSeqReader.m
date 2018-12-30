% return  seqence object of thermal image

%Input : 
% data_filepath = the path of input file

%Output : 
%   seq = seqence object of thermal image
%   fr = frame rate
%   fc = frame count

function [seq,fr,fc]=GetThermalSeqReader(data_filepath)
tic
% Load the Atlats SDK
atPath =getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
NET.addAssembly(atImage);

%open the IR-file
file = Flir.Atlas.Image.ThermalImageFile(data_filepath);
seq = file.ThermalSequencePlayer();
if seq.FrameRate==7
    seq.FrameRate=7.5;
end;
fr = seq.FrameRate;
fc = seq.Count;
toc
