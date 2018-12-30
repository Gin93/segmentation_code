% return thermal image information (image and temperature values);

%Input :
%   seq = seqence object of thermal image
%   fn  = frame numner (start from 1)

%Output :
% tSignalImg  = thermal signal image
% tvals = temperature values (The size of it is equal with timg)

function [tSignalImg,tvals]=GetThermalFrame(seq,fn)

seq.SelectedIndex=fn-1;

%Get the pixels
img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
tSignalImg = double(img);

w=seq.ThermalImage.Width;
h=seq.ThermalImage.Height;
rect=System.Drawing.Rectangle(0, 0,w, h);
tvals_1D=seq.ThermalImage.GetValues(rect).double;

tvals=zeros(h,w);
for i=1:h
    for j=1:w
        idx=(i-1)*w+j;
        tvals(i,j)=tvals_1D(idx);
    end
end





