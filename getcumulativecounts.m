function [cumulativeSignalCounts] = getcumulativecounts(inputSignal,signalThreshold)
% get cumulative event counts from a single rotary encoder channel

cumulativeSignalCounts = 0;
lenChannel = length(inputSignal);
aboveThreshold = false ;
i=1;

for i=1:lenChannel
    if inputSignal(i)<2.5
        aboveThreshold = false ;
        i=+1;
    elseif inputSignal(i)>2.5
        cumulativeSignalCounts=+1;
        aboveThreshold = true;
        i=+1; 
        %wait until signal drops below threshold 
        while aboveThreshold == true & i<lenChannel
            i=+1;
        end
    end
end

