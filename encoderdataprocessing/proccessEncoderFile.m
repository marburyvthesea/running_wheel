function [outputTable] = processEncoderFile(inputEncoderDataPath, inputEncoderDataFile, inputEncoderTimeStampsFile)

%% load rotary encoder data and create a matlab time table
%encoderTimeStamps=readmatrix(strcat(encoderDataPath, encoderTimeStampsFile), 'OutputType', 'datetime');
%encoderData=readmatrix(strcat(encoderDataPath, encoderDataFile));
encoderData=csvread(strcat(inputEncoderDataPath,inputEncoderDataFile));
encoderTimeStamps=readtable(strcat(inputEncoderDataPath,inputEncoderTimeStampsFile));

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
Threshold=2;
thresholdCrossingIndiciesA = getPositiveThresholdCrossingsFromChannel(encoderTimeStamps.Channel1, 2);
thresholdCrossingIndiciesB = getPositiveThresholdCrossingsFromChannel(encoderTimeStamps.Channel4, 2);
thresholdCrossingTimesA = encoderTimeStamps.Var1(thresholdCrossingIndiciesA);
thresholdCrossingTimesB = encoderTimeStamps.Var1(thresholdCrossingIndiciesB);
crossingIntervalsA = diff(thresholdCrossingTimesA);

%%
%get instantaneous rotation frequency from one channel to get "absoulte
%value" of velocity 
instantaneousIntervalArray=zeros(length(encoderTimeStamps.Channel1), 1);
instantaneousIntervalArray(1:thresholdCrossingIndiciesA(1), 1) = nan ; 
for i=1:length(thresholdCrossingIndiciesA)-1
    instantaneousIntervalArray(thresholdCrossingIndiciesA(i):thresholdCrossingIndiciesA(i+1), 1) = seconds(crossingIntervalsA(i));    
end
instantaneousIntervalArray(thresholdCrossingIndiciesA(length(thresholdCrossingIndiciesA)):length(encoderTimeStamps.Channel1), 1) = nan;
velocityArray = 1./instantaneousIntervalArray;

%% find direction of velocity 
%compare timing of pulses, either "A" preceedes "B" or "B","A"
velocityDirection=zeros(length(encoderTimeStamps.Channel1), 1);
velocityDirection(1:min(thresholdCrossingIndiciesA(1),thresholdCrossingIndiciesB(1)), 1) = nan ;
for i=1:min(length(thresholdCrossingIndiciesA), length(thresholdCrossingIndiciesB))
    if thresholdCrossingIndiciesA(i)<thresholdCrossingIndiciesB(i)
        velocityDirection(thresholdCrossingIndiciesA(i):thresholdCrossingIndiciesA(i+1), 1) = 1; 
    else 
        velocityDirection(thresholdCrossingIndiciesB(i):thresholdCrossingIndiciesB(i+1), 1) = -1;
    end
end
% make directional velocity array
directionalVelocity=velocityArray.*velocityDirection; 
%% add to table 
% 
encoderTimeStamps.('absoluteVelocity')=velocityArray;
encoderTimeStamps.('vectorVelocity')=directionalVelocity;
encoderTimeStamps.('instantaneousIntervals')=instantaneousIntervalArray;
%% load video time stamp file and add in column with frame number and video file
%videoTimeStamps=readmatrix(strcat(encoder_data_path, videoTimeStampsFile), 'OutputType', 'datetime');

end 