
%% load up encoder data files to get instantaneous velocity 

disp('load rotary encoder data file');
[encoderDataFile, encoderDataPath] = uigetfile('*.csv','File Selector');
disp('load rotary encoder timestamps file');
[encoderTimeStampsFile, encoderDataPath] = uigetfile('*.csv','File Selector');

%% load rotary encoder data and create a matlab time table
%encoderTimeStamps=readmatrix(strcat(encoderDataPath, encoderTimeStampsFile), 'OutputType', 'datetime');
%encoderData=readmatrix(strcat(encoderDataPath, encoderDataFile));
encoderData=csvread(strcat(encoderDataPath,encoderDataFile));
encoderTimeStamps=readtable(strcat(encoderDataPath,encoderTimeStampsFile));

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



%% load video time stamp file and add in column with frame number and video file
%videoTimeStamps=readmatrix(strcat(encoder_data_path, videoTimeStampsFile), 'OutputType', 'datetime');