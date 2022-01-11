function [samplingIntervals] = getEncoderSampleIntervals(inputEncoderTimeVec)

inputArraySize = size(inputEncoderTimeVec);

samplingIntervals = zeros(inputArraySize(1,1)-1, 1);

for i=1:inputArraySize(1,1)-1

    samplingIntervals(i,1) =  etime(inputEncoderTimeVec(i+1, :), inputEncoderTimeVec(i, :));
    
    
end

