function [outputState] = removeChannelsRelaseDaq(session)


num_channels=length(session.Channels);

while num_channels>0
    removeChannel(session,1);
    num_channels=length(session.Channels);
end
    
release(session); 
outputState='closed DAQ session';
end

