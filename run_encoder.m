
[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'winvideo', ...
    'behavCam_devicenum', 1, ...
    'behavCam_imgformat', 'MJPG_1024x576');

%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', ...
%    'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');



%%

num_video_sweeps = 40;
%num_encoder_sweeps = 2;

%%currently 10 fold higher sampling in encoder sweeps than video sweeps

%samples_to_acquire = 100000; 
%frames_to_acquire = 1000;
%samples_to_acquire = frames_to_acquire*10;
%enter sweep time in seconds 
sweepTime = 90 ;

for i=1:num_video_sweeps
disp('on sweep');
disp(i); 
    
f1 = parfeval(@singleCamAcquisitionDiskLoggingTimed, 1, behavCam, sweepTime, pdir, i);
%only run encoder while video is also acquiring 
if strcmp(f1.State, 'running')==1
    f2 = parfeval(@acquireEncoderSamplesParallelTimed, 3, sweepTime, pdir);
end

[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f2);
[outputState_cam] = fetchOutputs(f1);

end 
%%

cam = imaqfind; delete(cam);