% webcam : videoinput('winvideo', 2, 'MJPG_1024x576');
% wheel facing cam : videoinput('winvideo', 1, 'RGB24_320x240');

%%
%cam is photometry cam
[cam, behavCam, behavCam2, dq] = init_system_jjm('behavCam_name', 'off', ...
    'behavCam_devicenum', 2, ...
    'behavCam_imgformat', 'MJPG_1024x576', 'photometryCam_name', 'off', ...
    'photometryCam_devicenum', 3, 'photometryCam_imgformat', 'MJPG_1024x576', ...
    'behavCam2_name', 'winvideo', ...
    'behavCam2_devicenum', 1, 'behavCam2_imgformat', 'Y800_320x240', ...
    'DAQ', 'off');

%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', ...
%    'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');
%%
src=getselectedsource(behavCam2);
src.FrameRate = '160.0000';
src.ExposureMode = 'manual';
src.Brightness = 0;
src.Contrast = 0;
src.Exposure = -6;
src.Gain = 16;

%%
pdir = uigetdir ;
%%
num_video_sweeps = 1;
%num_encoder_sweeps = 2;

%%currently 10 fold higher sampling in encoder sweeps than video sweeps

%samples_to_acquire = 100000; 
%frames_to_acquire = 1000;
%samples_to_acquire = frames_to_acquire*10;
%enter sweep time in seconds 
sweepTime = 10 ;

%%restrict MATLAB cores for pool to keep resources for miniscope
%%software 
numcores=4;
maxNumCompThreads(numcores)
%create parallel pool with two workers
p = parpool(numcores);

for i=1:num_video_sweeps
disp('on sweep');
disp(i); 
    
%f1 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam, 1, sweepTime, pdir, i, 30);
f2 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam2, 0, sweepTime, pdir, i, 60);

%only run encoder while video is also acquiring 
%[outputState_cam] = fetchOutputs(f1);
%[outputState_pCam] = fetchOutputs(f3);
[outputState_cam2] = fetchOutputs(f2);
%[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f2);
end

poolobj = gcp('nocreate');
delete(poolobj);
%%
poolobj = gcp('nocreate');
delete(poolobj);
%cam = imaqfind; delete(cam);