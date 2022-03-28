%%load up rotary encoder data in a directory and process 

dataDirectory = uigetdir ; 
analysisDirectory = '/Users/johnmarshall/Documents/Analysis/running_wheel_analysis/';
dirParts = strsplit(dataDirectory, '/');
saveName = dirParts{1, length(dirParts)};

listingTimeStamps = struct2table(dir(strcat(dataDirectory, '/*', 'rotary_test_out_timestamps.csv')));
listingEncoderData = struct2table(dir(strcat(dataDirectory, '/*', 'rotary_test_out.csv')));

outputTable = processEncoderFile(listingTimeStamps.folder{1,1}, listingEncoderData.name{1,1}, listingTimeStamps.name{1,1}); 

%%
%
for i=2:height(listingTimeStamps)
    nextOutputTable = processEncoderFile(listingTimeStamps.folder{i,1}, listingEncoderData.name{i,1}, listingTimeStamps.name{i,1});
    outputTable = [outputTable; nextOutputTable];
end
% save to output variable
save(strcat(analysisDirectory, saveName, '.mat'), 'outputTable');


