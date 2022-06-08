%%load up rotary encoder data in a directory and process 

dataDirectory = uigetdir ; 
analysisDirectory = 'F:\JJM\running_wheel_analysis\r2_8_day_1\';
dirParts = strsplit(dataDirectory, '\');
saveName_01 = dirParts{1, length(dirParts)};
saveName_00 = dirParts{1, length(dirParts)-1};

listingTimeStamps = struct2table(dir(strcat(dataDirectory, '\*', 'rotary_test_out_timestamps.csv')));
listingEncoderData = struct2table(dir(strcat(dataDirectory, '\*', 'rotary_test_out.csv')));

outputTable = processEncoderFile(listingTimeStamps.folder{1,1}, listingEncoderData.name{1,1}, listingTimeStamps.name{1,1}); 

%%
%
for i=2:height(listingTimeStamps)
    nextOutputTable = processEncoderFile(listingTimeStamps.folder{i,1}, listingEncoderData.name{i,1}, listingTimeStamps.name{i,1});
    outputTable = [outputTable; nextOutputTable];
end
% save to output variable
disp('saving')
save(strcat(analysisDirectory, saveName_00, '_',saveName_01, '.mat'), 'outputTable');
writetable(outputTable, strcat(analysisDirectory, saveName_00, '_',saveName_01, '.csv'), 'Delimiter',';');
disp('saved')
disp(strcat(analysisDirectory, saveName_00, '_',saveName_01, '.mat'))

