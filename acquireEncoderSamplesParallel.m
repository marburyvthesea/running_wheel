function [outputState, data, triggerTimes] = acquireEncoderSamplesParallel(numSamples, saveDir)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
dq = daq.createSession('ni');
ch=dq.addAnalogInputChannel('Dev1',0:6,'Voltage');
[outputState, data, triggerTimes] = acquireEncoderSamples(numSamples,dq, saveDir);

outputState = removeChannelsRelaseDaq(dq);

end

