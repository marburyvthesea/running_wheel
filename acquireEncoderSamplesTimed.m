function [outputState, dataTimeSeries, triggerTimes] = acquireEncoderSamplesTimed(sweepTimeSeconds,daqSession, saveDir)
outputState='running';
%for logging data 
filetime = datestr(datetime,'yyyymmdd-HH-MM-SS');

% 8 channels from rotary encoder
dataTimeSeries = zeros(1,8); 

%get current time
start_time = datetime('now', 'format', 'HH:mm:ss.SSS');
current_time = datetime('now', 'format', 'HH:mm:ss.SSS');

%triggerTimes = zeros(numSamples,6);
triggerTimes = datetime('now', 'format', 'HH:mm:ss.SSS');

while seconds(current_time-start_time) < sweepTimeSeconds
    
    [data,~] = inputSingleScan(daqSession);
    dataTimeSeries = [dataTimeSeries ;data] ;
    triggerTimes = [triggerTimes ; datetime('now', 'format', 'HH:mm:ss.SSS')];
    current_time = datetime('now', 'format', 'HH:mm:ss.SSS');
    
end
    
exp_name = [saveDir, '\', filetime, 'rotary_test_out.csv'] ; 
timestamps_name = [saveDir, '\', filetime, 'rotary_test_out_timestamps.csv'] ;
writematrix(dataTimeSeries, exp_name) ;
writematrix(triggerTimes, timestamps_name) ;

outputState='finished';
end

