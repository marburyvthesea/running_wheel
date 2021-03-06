function [outputArg1,outputArg2] = loadAlignEncoderToVideosMiniscope()

[filename, folder] = uigetfile('*.avi','File Selector');

% load rotary encoder data and create a matlab time table
encoderTimeStamps=readmatrix(strcat(encoder_data_path, encoderTimeStampsFile), 'OutputType', 'datetime');
encoderData=readmatrix(strcat(encoder_data_path, encoder_DataFile));
encoderTimeTable=timetable(encoderTimeStamps,encoderData);

% load video time stamp file and add in column with frame number and video file
videoTimeStamps=readmatrix(strcat(encoder_data_path, videoTimeStampsFile), 'OutputType', 'datetime');



end

