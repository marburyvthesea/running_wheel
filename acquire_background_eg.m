
s = daq.createSession('ni');
addAnalogInputChannel(s,'cDAQ1Mod1','ai0','Voltage');
lh = addlistener(s,'DataAvailable',@plotData); 
 
function plotData(src,event)
     plot(event.TimeStamps,event.Data)
end


startBackground(s);