%##### Load image #####
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile('*.jpg;*.seq', 'Choose IR file (jpg) or radiometric sequence (seq)');
videoFileName=[PATHNAME FILENAME];

% Load the Atlats SDK
atPath = getenv('FLIR_Atlas_MATLAB');
atImage = strcat(atPath,'Flir.Atlas.Image.dll');
asmInfo = NET.addAssembly(atImage);
%open the IR-file
file = Flir.Atlas.Image.ThermalImageFile(videoFileName);
seq = file.ThermalSequencePlayer();
%Get the pixels
img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
im = double(img);
%show image
figure(1)
imshow(im,[])
figure(2)
    %seq.ThermalImage.TemperatureUnit = Flir.Atlas.Image.TemperatureUnit.Celsius; 
    h = animatedline;
    %setup plot (Matlab2014b or later)
    max=seq.ThermalImage.GetValueFromSignal(seq.ThermalImage.MaxSignalValue);
    min=seq.ThermalImage.GetValueFromSignal(seq.ThermalImage.MinSignalValue);
    axis([0 (double(seq.Count)/double(seq.FrameRate)) (min-2) (max+2)])
    xline = linspace(0,(double(seq.Count)/double(seq.FrameRate)),seq.Count);
    title('Temp at position 10,10') 
    ylabel('C')
    xlabel('Time(Sec)')
if(seq.Count > 1)
    while(seq.Next())
        img = seq.ThermalImage.ImageProcessing.GetPixelsArray;
        im = double(img);
        %get the temperature for position 10,10
        temp = seq.ThermalImage.GetValueFromSignal(im(10,10));
        
        %plot temp vs time(Sec) 
        addpoints(h,xline(seq.SelectedIndex),temp);

        figure(1)
        imshow(im,[]);
        drawnow;
    end
end