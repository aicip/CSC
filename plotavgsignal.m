close all
clc
warning off

%% load single files
dataPath = '..\Signal\M3C\';
files = dir(fullfile(dataPath,'*.mat'));
for loop=1:length(files)
    y = importdata(strcat(dataPath, files(loop).name));
    avg =mean(y,2);
    y = avg;
    figure;
    plot(y);
    waitforbuttonpress;
    
end
    