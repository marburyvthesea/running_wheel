function [outputState, dataTimeSeries, triggerTimes] = acquireEncoderSamples(numSamples,daqSession, saveDir)
outputState='running';
%for logging data 
filetime = datestr(datetime,'yyyymmdd-HHMM');

%triggerTimes = datetime(zeros(numSamples,1), 0, 0, 'format', 'HH:mm:ss.SSS');
triggerTimes = zeros(numSamples,6); 
% 7 channels from rotary encoder
dataTimeSeries = zeros(numSamples,7); 

for i = 1:numSamples
    [data,~] = inputSingleScan(daqSession);
    dataTimeSeries(i,:) = data;
    triggerTimes(i,:) = clock;
end
    
exp_name = [saveDir, '\', filetime, 'rotary_test_out.csv'] ; 
timestamps_name = [saveDir, '\', filetime, 'rotary_test_out_timestamps.csv'] ;
writematrix(dataTimeSeries, exp_name) ;
writematrix(triggerTimes, timestamps_name) ;

outputState='finished';
end

