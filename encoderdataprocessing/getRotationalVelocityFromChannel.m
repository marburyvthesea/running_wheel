function [instantaneousIntervalArray, velocityArray] = getRotationalVelocityFromChannel(inputEncoderChannel, inputThresholdCrossingIndiciesFromChannel)
%get instantaneous rotation frequency from traces of individual encoder
%channels 

instantaneousIntervalArray=zeros(length(inputEncoderChannel), 1);

instantaneousIntervalArray(1:inputThresholdCrossingIndiciesFromChannel(1), 1) = nan ; 

for i=1:length(inputThresholdCrossingIndiciesFromChannel)-1
    instantaneousIntervalArray(inputThresholdCrossingIndiciesFromChannel(i):inputThresholdCrossingIndiciesFromChannel(i+1), 1) = seconds(crossingIntervalsA(i));    
end

instantaneousIntervalArray(inputThresholdCrossingIndiciesFromChannel(length(inputThresholdCrossingIndiciesFromChannel)):length(inputEncoderChannel), 1) = nan;

velocityArray = 1./instantaneousIntervalArray; 
end

