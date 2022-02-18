function [outputStatus, vidfileName] = singleCamAcquisitionDiskLoggingTimed(inputCam, camNum, sweepTimeSeconds, pdir, sweepNum, freq)
 
%%init
triggerconfig(inputCam, 'manual');
inputCam.FramesPerTrigger = 1;
inputCam.TriggerRepeat = Inf;


%
filetime = datestr(datetime,'yyyymmdd-HH-MM-SS');
save_dir = pdir ;
addpath(genpath(save_dir)) ;
vidfileName = [save_dir, '\', filetime, '_', num2str(sweepNum), '_', imaqhwinfo(inputCam).AdaptorName, ...
    '_', imaqhwinfo(inputCam).DeviceName, '_' , num2str(camNum)];

%
vidfile = VideoWriter(vidfileName);
vidfile.FrameRate = freq ;
inputCam.LoggingMode = 'disk';
inputCam.DiskLogger = vidfile;

%get current time
startTime = datetime('now', 'format', 'HH:mm:ss.SSS');
currentTime = datetime('now', 'format', 'HH:mm:ss.SSS');

%frameTimes = datetime(zeros(frames,1), 0, 0, 'format', 'HH:mm:ss.SSS');
frameTimes = datetime('now', 'format', 'HH:mm:ss.SSS');

open(vidfile);
start(inputCam);

while seconds(currentTime-startTime) < sweepTimeSeconds
%for i = 1:frames

    if islogging(inputCam)== 0
        trigger(inputCam) ;
        frameTimes = [frameTimes ; datetime('now', 'format', 'HH:mm:ss.SSS')];
    else 
        disp('waiting for disk writing');        
        while islogging(inputCam)== 1 
            java.lang.Thread.sleep(1); 
        end 
    end 
    disp('frames acquired from stream');
    disp(inputCam.FramesAcquired); 
    disp('frames logged to disk');
    disp(inputCam.DiskLoggerFrameCount); 
    
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
    '_', imaqhwinfo(inputCam).DeviceName, '_' , num2str(camNum) , '_time','.csv'];
writematrix(frameTimes, expname);

outputStatus='done';
%disp(['finished'+outputStatus]);
end



