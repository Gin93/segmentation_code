% return a point temperature at selected frame

%Input : 
%   seq = seqence object of thermal image
%   fn  = frame numner (start from 1)
%   x= x position of thermal image (start from 1)
%   y= y position of thermal image (start from 1)

%Output : 
% tval = temperature of point (x,y) at frame fn

function [tval]=GetThermalValueAt(seq,fn,x,y)

seq.SelectedIndex=fn-1;

p=System.Drawing.Point(x-1,y-1);
tval=seq.ThermalImage.GetValueAt(p).Value;

