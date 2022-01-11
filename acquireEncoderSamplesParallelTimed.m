function [outputState, data, triggerTimes] = acquireEncoderSamplesParallelTimed(sweepTimeSeconds, saveDir)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
dq = daq.createSession('ni');
ch=dq.addAnalogInputChannel('Dev1',0:7,'Voltage');
[outputState, data, triggerTimes] = acquireEncoderSamplesTimed(sweepTimeSeconds,dq, saveDir);

outputState = removeChannelsRelaseDaq(dq);

end

