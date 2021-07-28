

%% translate encoder traces to velocity

% A&B channels 
% A = encoder_data{:,1}
% B = encoder_data{:,5}
% index = encoder_data{:,3}

% 1000 CPR, 225 ppr 

% B leads A for clockwise shaft rotation
% A leads B for counterclockwise rotation when viewed from the shaft side of the encoder

% for channels A&B convert to cumulative counts, get thresold crossings


