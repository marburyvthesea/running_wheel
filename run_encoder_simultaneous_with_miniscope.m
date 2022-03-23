% webcam : videoinput('winvideo', 2, 'MJPG_1024x576');
% wheel facing cam : videoinput('winvideo', 1, 'RGB24_320x240');

%%
%cam is photometry cam
[cam, behavCam, behavCam2, dq] = init_system_jjm('behavCam_name', 'winvideo', ...
    'behavCam_devicenum', 1, ...
    'behavCam_imgformat', 'Y800_320x240', 'photometryCam_name', 'winvideo', ...
    'photometryCam_devicenum', 3, 'photometryCam_imgformat', 'MJPG_1024x576', ...
    'behavCam2_name', 'off', ...
    'behavCam2_devicenum', 1, 'behavCam2_imgformat', 'Y800_320x240', ...
    'DAQ', 'ni');

%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', ...
%    'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');
%%
src=getselectedsource(behavCam);
src.FrameRate = '160.0000';
src.ExposureMode = 'manual';
src.Exposure = -8;
%%
src1=getselectedsource(cam);
src1.Brightness = 200;

%%
pdir = uigetdir ;
%%%restrict MATLAB cores for pool to keep resources for miniscope
%%software 
%%
numcores=7;
maxNumCompThreads(numcores)
%create parallel pool with two workers
p = parpool(numcores);%
%implay()

%%
num_video_sweeps = 14;
sweepTime = 90 ;
for i=1:num_video_sweeps
disp('on sweep');
disp(i); 
    
f1 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 2, behavCam, 1, sweepTime, pdir, i, 160);
f3 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 2, cam, 3, sweepTime, pdir, i, 30);

%only run encoder while video is also acquiring
%TTLs from miniscope should be AI 1 
if strcmp(f1.State, 'running')==1
    f2 = parfeval(p, @acquireEncoderSamplesParallelTimed, 3, sweepTime, pdir);

%if i>1
%    implay(strcat(vidfile_cam, '.avi'))
%end

[outputState_behavCam, vidfile_behavCam] = fetchOutputs(f1);
[outputState_cam, vidfile_cam] = fetchOutputs(f3);
[outputState_encoder] = fetchOutputs(f2);

end

end
%%
delete(gcp('nocreate'))
%%
cam = imaqfind; delete(cam);