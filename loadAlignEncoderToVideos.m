
%variables for each file 
encoder_data_path = 'C:\Users\jma819\Documents\JJM\rotary_encoder_data\008_day24\' ;
encoderTimeStampsFile='20211011-1519rotary_test_out_timestamps' ;
videoTimeStampsFile='20211011-1519winvideo_DMK 22BUC03_3_time' ;

% load rotary encoder data and create a matlab time table
encoderTimeStamps=readmatrix(strcat(encoder_data_path, encoderTimeStampsFile), 'OutputType', 'datetime');
encoderData=readmatrix(strcat(encoder_data_path, encoder_DataFile));
encoderTimeTable=timetable(encoderTimeStamps,encoderData);

% estimate speed 
encoderTimeVec = datevec(datenum(encoderTimeStamps));
encoderSamplingIntervals = getEncoderSampleIntervals(encoderTimeVec);
meanSI = mean(SIs); 

% load video time stamp file and add in column with frame number and video file
videoTimeStamps=readmatrix(strcat(encoder_data_path, videoTimeStampsFile), 'OutputType', 'datetime');