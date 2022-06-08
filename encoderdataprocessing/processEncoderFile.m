function [encoderOutput] = processEncoderFile(inputEncoderDataPath, inputEncoderDataFile, inputEncoderTimeStampsFile)
%% load rotary encoder data and create a matlab time table

disp('opening');
disp(inputEncoderDataPath);
disp(inputEncoderDataFile);

%encoderTimeStamps=readmatrix(strcat(encoderDataPath, encoderTimeStampsFile), 'OutputType', 'datetime');
%encoderData=readmatrix(strcat(encoderDataPath, encoderDataFile));
encoderData=csvread(strcat(inputEncoderDataPath, '/',inputEncoderDataFile));
encoderTimeStamps=readtable(strcat(inputEncoderDataPath, '/',inputEncoderTimeStampsFile));

%add encoder data to timestamps table
%this should be channel A 
encoderTimeStamps.Channel1 = encoderData(:, 1);
encoderTimeStamps.Channel2 = encoderData(:, 2);
encoderTimeStamps.Channel3 = encoderData(:, 3);
%this should be channel B
encoderTimeStamps.Channel4 = encoderData(:, 4);
encoderTimeStamps.Channel5 = encoderData(:, 5);
encoderTimeStamps.Channel6 = encoderData(:, 6);
encoderTimeStamps.Channel7 = encoderData(:, 7);
encoderTimeStamps.Channel8 = encoderData(:, 8);
%%
%%find threshold crossings in channel A & B
threshold=2;
thresholdCrossingIndiciesA = getPositiveThresholdCrossingsFromChannel(encoderTimeStamps.Channel1, threshold);
thresholdCrossingIndiciesB = getPositiveThresholdCrossingsFromChannel(encoderTimeStamps.Channel4, threshold);
thresholdCrossingTimesA = encoderTimeStamps.Var1(thresholdCrossingIndiciesA);
thresholdCrossingTimesB = encoderTimeStamps.Var1(thresholdCrossingIndiciesB);
crossingIntervalsA = diff(thresholdCrossingTimesA);

%%
%get instantaneous rotation frequency from one channel to get "absoulte
%value" of velocity 
instantaneousIntervalArray=zeros(length(encoderTimeStamps.Channel1), 1);
if ~isempty(thresholdCrossingIndiciesA)
    instantaneousIntervalArray(1:thresholdCrossingIndiciesA(1), 1) = seconds(thresholdCrossingTimesA(1,1)-encoderTimeStamps.Var1(1,1)); 
    for i=1:length(thresholdCrossingIndiciesA)-1
        instantaneousIntervalArray(thresholdCrossingIndiciesA(i):thresholdCrossingIndiciesA(i+1), 1) = seconds(crossingIntervalsA(i));    
    end
    instantaneousIntervalArray(thresholdCrossingIndiciesA(length(thresholdCrossingIndiciesA)):length(encoderTimeStamps.Channel1), 1) = seconds(encoderTimeStamps.Var1(length(encoderTimeStamps.Var1),1)-thresholdCrossingTimesA(length(thresholdCrossingTimesA),1));
end    

velocityArray = 1./instantaneousIntervalArray;

%% find direction of velocity 
%compare timing of pulses, either "A" preceedes "B" or "B","A"
velocityDirection=zeros(length(encoderTimeStamps.Channel1), 1);

if length(thresholdCrossingIndiciesA) && length(thresholdCrossingIndiciesB)>1 
    velocityDirection(1:min(thresholdCrossingIndiciesA(1),thresholdCrossingIndiciesB(1)), 1) = nan ;
    for i=1:min(length(thresholdCrossingIndiciesA), length(thresholdCrossingIndiciesB)) 
        if thresholdCrossingIndiciesA(i)<thresholdCrossingIndiciesB(i) && i+1<length(thresholdCrossingIndiciesA)
            velocityDirection(thresholdCrossingIndiciesA(i):thresholdCrossingIndiciesA(i+1), 1) = 1; 
        elseif thresholdCrossingIndiciesA(i)<thresholdCrossingIndiciesB(i) && ~(i+1<length(thresholdCrossingIndiciesA))
            velocityDirection(thresholdCrossingIndiciesA(i), 1) = 1;        
        elseif thresholdCrossingIndiciesA(i)>thresholdCrossingIndiciesB(i) && i+1<length(thresholdCrossingIndiciesB)
            velocityDirection(thresholdCrossingIndiciesB(i):thresholdCrossingIndiciesB(i+1), 1) = -1;
        else 
            velocityDirection(thresholdCrossingIndiciesB(i), 1) = -1;
        end
    end
else
    velocityDirection=zeros(length(encoderTimeStamps.Channel1), 1);    
end
% make directional velocity array
directionalVelocity=velocityArray.*velocityDirection;
%% add to table 
% 
encoderTimeStamps.('absoluteVelocity')=velocityArray;
encoderTimeStamps.('vectorVelocity')=directionalVelocity;
encoderTimeStamps.('instantaneousIntervals')=instantaneousIntervalArray;
encoderTimeStamps.('miniscopeFrameGrabTTL')=encoderTimeStamps.Channel2;

%% add variable for filename
encoderTimeStamps.('FileName')=repmat(inputEncoderDataFile, size(encoderTimeStamps, 1), 1);

encoderOutput = encoderTimeStamps;
%% load video time stamp file and add in column with frame number and video file
%videoTimeStamps=readmatrix(strcat(encoder_data_path, videoTimeStampsFile), 'OutputType', 'datetime');

end 