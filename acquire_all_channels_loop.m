% define numSamples, dqSession outside loop

%triggerTimes = datetime(zeros(numSamples,1), 0, 0, 'format', 'HH:mm:ss.SSS');
triggerTimes = zeros(numSamples,1); ;
% 7 channels from rotary encoder
dataTimeSeries = zeros(numSamples,7); 

for i = 1:numSamples
    [data,triggerTime] = inputSingleScan(dq);
    dataTimeSeries(i,:) = data;
    triggerTimes(i,:) = triggerTime;
end
    
save_dir = 'C:\Users\jma819\Documents\JJM\rotary_encoder_data\test_out.txt'
exp_name = [save_dir, '\', 'test_out.csv']
writematrix(dataTimeSeries, exp_name)
