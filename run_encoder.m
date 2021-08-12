
[pdir, cam, behavCam, dq] = init_system_jjm('behavCam_name', 'winvideo', ...
    'behavCam_devicenum', 1, ...
    'behavCam_imgformat', 'MJPG_1024x576');

%%

num_sweeps = 30;

samples_to_acquire = 1000; 
frames_to_acquire = 1000;

for i=1:num_sweeps

f1 = parfeval(@acquireEncoderSamplesParallel, 3, samples_to_acquire, pdir);
f2 = parfeval(@singleCamAcquisition_disklogging, 1, behavCam, frames_to_acquire, pdir); 

[outputState_encoder, encoderData, triggerTimes] = fetchOutputs(f1);
[outputState_cam] = fetchOutputs(f2);

end 
%%

cam = imaqfind; delete(cam);