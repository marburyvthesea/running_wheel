function [outputStatus] = singleCamAcquisitionDiskLoggingTimedFast(inputCam, sweepTimeSeconds, pdir, sweepNum)
 
%%init
triggerconfig(inputCam, 'manual');
inputCam.FramesPerTrigger = 1;
inputCam.TriggerRepeat = Inf;
freq = 20 ;

%
filetime = datestr(datetime,'yyyymmdd-HHMM');
save_dir = pdir ;
addpath(genpath(save_dir)) ;
vidfile = [save_dir, '\', filetime, '_', num2str(sweepNum), '_', imaqhwinfo(inputCam).AdaptorName, ...
    '_', imaqhwinfo(inputCam).DeviceName];

%
vidfile = VideoWriter(vidfile);
vidfile.FrameRate = freq ;
inputCam.LoggingMode = 'disk';
inputCam.DiskLogger = vidfile;

%get current time
startTime = datetime('now', 'format', 'HH:mm:ss.SSS');
currentTime = datetime('now', 'format', 'HH:mm:ss.SSS');

%frameTimes = datetime(zeros(frames,1), 0, 0, 'format', 'HH:mm:ss.SSS');
frameTimes = datetime('now', 'format', 'HH:mm:ss.SSS');

src = getselectedsource(inputCam);
src.FrameRate = '160.00';

open(vidfile);
start(inputCam);

while seconds(currentTime-startTime) < sweepTimeSeconds
%for i = 1:frames

    if islogging(inputCam)== 0
        trigger(inputCam) ;
        %frameTimes = [frameTimes ; datetime('now', 'format', 'HH:mm:ss.SSS')];
    end    
    currentTime = datetime('now', 'format', 'HH:mm:ss.SSS');
    
end
%wait for final frame 
if inputCam.DiskLoggerFrameCount~=inputCam.FramesAcquired
    pause(0.1);
end
disp('frames acquired from stream');
disp(inputCam.FramesAcquired); 
disp('frames logged to disk');
disp(inputCam.DiskLoggerFrameCount); 
close(vidfile) ;
stop(inputCam) ; 
delete(vidfile) ;
clear vidfile ; 
%end 
disp('Done') ;

expname = [save_dir, '\', filetime,imaqhwinfo(inputCam).AdaptorName, ...
    '_', imaqhwinfo(inputCam).DeviceName, '_time','.csv'];
writematrix(frameTimes, expname);

outputStatus='done';
%disp(['finished'+outputStatus]);
end



