function [thresholdCrossingIndicies] = getPositiveThresholdCrossingsFromChannel(inputChannel, threshold)
% return indicies where thresholds crossing positive going, discard
% negative going 

aboveThresholdMask = inputChannel>=threshold;
aboveThresholdMask(1) = 0;
indiciesAboveThreshold = find(aboveThresholdMask);
priorIndexBelowThreshold = inputChannel(indiciesAboveThreshold-1)<threshold;
priorIndiciesBelowThreshold = find(priorIndexBelowThreshold);
thresholdCrossingIndicies=indiciesAboveThreshold(priorIndiciesBelowThreshold);

end

