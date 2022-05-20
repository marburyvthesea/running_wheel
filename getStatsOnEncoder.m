function [statsTable,smoothedVelocity] = getStatsOnEncoder()
%% do some stats on encoder output tables

[encoderOutputFile, encoderDataPath] = uigetfile('*.mat','File Selector');
encoderOutput=load(strcat(encoderDataPath, '/', encoderOutputFile));
encoderOutputTable=encoderOutput.outputTable; 

% get percent of time active
positiveVelocity = encoderOutputTable.absoluteVelocity>2;
percentActive = sum(positiveVelocity(:) == 1)/length(positiveVelocity);

% smooth velocity data and calculate maximum 

%B = smoothdata(___,method,window)
%B = smoothdata(___,nanflag)

smoothedVelocity = smoothdata(encoderOutputTable.absoluteVelocity, 'gaussian', 100, 'includenan');

maxSmoothedVelocity = max(smoothedVelocity( ~any( isnan( smoothedVelocity ) | isinf( smoothedVelocity ), 2 ),: ));
meanSmoothedVelocity = mean(smoothedVelocity( ~any( isnan( smoothedVelocity ) | isinf( smoothedVelocity ), 2 ),: ));

statsTable = table(percentActive, maxSmoothedVelocity, meanSmoothedVelocity);
statsTable.('FileName')=repmat(encoderOutputFile, size(1,1), 1);

end

