%get instantaneous rotation frequency

instantaneousIntervalArray=zeros(length(encoderTimeStamps.Channel1), 1);

instantaneousIntervalArray(1:thresholdCrossingIndiciesA(1), 1) = nan ; 


for i=1:length(thresholdCrossingIndiciesA)-1
    instantaneousIntervalArray(thresholdCrossingIndiciesA(i):thresholdCrossingIndiciesA(i+1), 1) = seconds(crossingIntervalsA(i));
    
end


instantaneousIntervalArray(thresholdCrossingIndiciesA(length(thresholdCrossingIndiciesA)):length(encoderTimeStamps.Channel1), 1) = nan;

velocityArray = 1./instantaneousIntervalArray; 
    
    