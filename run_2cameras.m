%'behavCam_name', 'winvideo', ...
%    'behavCam_devicenum', 1, ...
%    'behavCam_imgformat', 'Y800_320x240',

[cam, behavCam, behavCam2, dq] = init_system_jjm('behavCam_name', 'winvideo', ...
    'behavCam_devicenum', 1, ...
    'behavCam_imgformat', 'Y800_320x240', 'photometryCam_name', 'off', ...
    'photometryCam_devicenum', 3, 'photometryCam_imgformat', 'MJPG_1024x576', ...
    'behavCam2_name', 'winvideo', ...
    'behavCam2_devicenum', 4, 'behavCam2_imgformat', 'Y800_320x240', ...
    'DAQ', 'ni');

%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', ...
%    'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');
%%
src=getselectedsource(behavCam);
src2=getselectedsource(behavCam2);

%%
pdir = uigetdir ;
%%
numcores=7;
maxNumCompThreads(numcores);
%create parallel pool with two workers
p = parpool(numcores);%
%implay()
%%
num_video_sweeps = 2;
%num_encoder_sweeps = 2;
src.ExposureMode = 'manual';
src2.ExposureMode = 'manual';
src2.FrameRate = '80.0000';
src.FrameRate = '160.0000';
src.Exposure = -6;
src2.Exposure = -6;

%enter sweep time in seconds 
sweepTime = 90 ;

%run camera warm up for 90 seconds  
disp('warming up');
f1 = parfeval(@singleCamWarmUpMemLog, 2, behavCam, 90);
f2 = parfeval(@singleCamWarmUpMemLog, 2, behavCam2, 90);
%f1 = parfeval(@singleCamWarmUp, 1, behavCam, 1, 90, pdir, i, str2num(src.FrameRate));
%f2 = parfeval(@singleCamWarmUp, 1, behavCam2, 3, 90, pdir, i, str2num(src2.FrameRate));

[outputState_cam, framesTriggered] = fetchOutputs(f1);
[outputState_cam2, framesTriggeredCam2] = fetchOutputs(f2);
disp('beginning acquisition');

for i=1:num_video_sweeps
disp('on sweep');
disp(i);     
f1 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam, 1, sweepTime, pdir, i, str2num(src.FrameRate));
%f3 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, cam, 0, sweepTime, pdir, i, 30);
f2 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam2, 3, sweepTime, pdir, i, str2num(src2.FrameRate));
%only run encoder while video is also acquiring 
%if strcmp(f1.State, 'running')==1
%    f2 = parfeval(@acquireEncoderSamplesParallelTimed, 3, sweepTime, pdir);
%end

[outputState_cam] = fetchOutputs(f1);
%[outputState_pCam] = fetchOutputs(f3);
[outputState_cam2] = fetchOutputs(f2);

%[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f2);
end 
%%

cam = imaqfind; delete(cam);
cam = imaqfind; delete(cam);
