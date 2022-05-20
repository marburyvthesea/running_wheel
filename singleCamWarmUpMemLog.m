function [outputStatus, framesTriggered] = singleCamWarmUpMemLog(inputCam, sweepTimeSeconds)
 
%%init
triggerconfig(inputCam, 'manual');
inputCam.FramesPerTrigger = 1;
inputCam.TriggerRepeat = Inf;


%
filetime = datestr(datetime,'yyyymmdd-HH-MM-SS');

%
inputCam.LoggingMode = 'memory';

%get current time
startTime = datetime('now', 'format', 'HH:mm:ss.SSS');
currentTime = datetime('now', 'format', 'HH:mm:ss.SSS');

%frameTimes = datetime(zeros(frames,1), 0, 0, 'format', 'HH:mm:ss.SSS');
frameTimes = datetime('now', 'format', 'HH:mm:ss.SSS');

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
    disp('frames available');
    disp(inputCam.FramesAvailable); 

    currentTime = datetime('now', 'format', 'HH:mm:ss.SSS');
    
end


stop(inputCam) ; 
%end 
disp('Done') ;

framesTriggered = inputCam.FramesAvailable;
outputStatus='done';

end



