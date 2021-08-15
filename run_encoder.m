
%[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'winvideo', ...
%    'behavCam_devicenum', 1, ...
%    'behavCam_imgformat', 'MJPG_1024x576');

[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'macvideo', 'behavCam_devicenum', 1, 'behavCam_imgformat', 'YCbCr422_1280x720');



%%

num_video_sweeps = 2;
%num_encoder_sweeps = 2;

%%currently 10 fold higher sampling in encoder sweeps than video sweeps

%samples_to_acquire = 100000; 
%frames_to_acquire = 1000;
%samples_to_acquire = frames_to_acquire*10;
sweepTime = 10

for i=1:num_video_sweeps
disp('on sweep');
disp(i); 
    
%f1 = parfeval(@acquireEncoderSamplesParallel, 3, samples_to_acquire, pdir); 
%only run encoder while video is also acquiring 
%if f1.State == 'running'
%    f2 = parfeval(@singleCamAcquisition_disklogging, 1, behavCam, frames_to_acquire, pdir);

f1 = singleCamAcquisitionDiskLoggingTimed(behavCam, sweepTime, pdir);
%f2 = parfeval(@acquireEncoderSamplesTimed, 3, sweepTime, pdir); 





[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f1);
[outputState_cam] = fetchOutputs(f2);

end 
%%

cam = imaqfind; delete(cam);