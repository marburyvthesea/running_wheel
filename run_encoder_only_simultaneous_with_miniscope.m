% webcam : videoinput('winvideo', 2, 'MJPG_1024x576');
% wheel facing cam : videoinput('winvideo', 1, 'RGB24_320x240');

%%currently all cameras set to off 

[cam, behavCam, behavCam2, dq] = init_system_jjm('behavCam_name', 'off', ...
    'behavCam_devicenum', 1, ...
    'behavCam_imgformat', 'Y800_320x240', 'photometryCam_name', 'off', ...
    'photometryCam_devicenum', 2, 'photometryCam_imgformat', 'MJPG_1024x576', ...
    'behavCam2_name', 'off', ...
    'behavCam2_devicenum', 3, 'behavCam2_imgformat', 'Y800_320x240', ...
    'DAQ', 'ni');

%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', ...
%    'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');
%%
%src=getselectedsource(behavCam);
%src.FrameRate = '160.0000';
%src.ExposureMode = 'manual';
%src.Brightness = 0;
%src.Contrast = 0;
%src.Exposure = -8;
%src.Gain = 16;

%%
pdir = uigetdir ;
%%
num_video_sweeps = 2;
%num_encoder_sweeps = 2;

%%currently 10 fold higher sampling in encoder sweeps than video sweeps

%samples_to_acquire = 100000; 
%frames_to_acquire = 1000;
%samples_to_acquire = frames_to_acquire*10;
%enter sweep time in seconds 
sweepTime = 30 ;

%%set MATLAB to only use 2 cores for pool to keep resources for miniscope
%%software 
maxNumCompThreads(2)
%create parallel pool with two workers
p = parpool(2);

for i=1:num_video_sweeps
disp('on sweep');
disp(i); 
    
%f1 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam, 1, sweepTime, pdir, i, 160);
%f3 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, cam, 0, sweepTime, pdir, i, 30);

%only run encoder while video is also acquiring 
%if strcmp(f1.State, 'running')==1
f2 = parfeval(p, @acquireEncoderSamplesParallelTimed, 3, sweepTime, pdir);


%[outputState_cam] = fetchOutputs(f1);
%[outputState_pCam] = fetchOutputs(f3);
[outputState_cam2] = fetchOutputs(f2);
end
%[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f2);

%%

%cam = imaqfind; delete(cam);