%define numSamples, dqSession outside loop

%for logging data 
filetime = datestr(datetime,'yyyymmdd-HHMM');

%triggerTimes = datetime(zeros(numSamples,1), 0, 0, 'format', 'HH:mm:ss.SSS');
triggerTimes = zeros(numSamples,6); 
% 7 channels from rotary encoder
dataTimeSeries = zeros(numSamples,7); 

for i = 1:numSamples
    [data,triggerTime] = inputSingleScan(dq);
    dataTimeSeries(i,:) = data;
    triggerTimes(i,:) = clock;
end
    
save_dir = 'C:\Users\jma819\Documents\JJM\rotary_encoder_data\' ; 
exp_name = [save_dir, '\', filetime, 'rotary_test_out.csv'] ; 
writematrix(dataTimeSeries, exp_name) ; 
