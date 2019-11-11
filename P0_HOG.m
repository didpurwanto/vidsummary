%% 
clc
clear
close all
tic;
%% Input file
srcFiles = dir('C:\Users\T2-503-3\Desktop\testITQ\Frame\person01_boxing_d1_uncomp\*.jpg');
totalVideo = length(srcFiles);
temp = [];
for j = 1 : totalVideo   % load the file

    filename = strcat('C:\Users\T2-503-3\Desktop\testITQ\Frame\person01_boxing_d1_uncomp\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    display('Load data ... ');
    jpgFilename = strcat(name, '.jpg');
    
    I = imread(filename);
    feature_hog = extractHOGFeatures(I);
    temp = [temp;feature_hog];
    clear feature_hog
    
    prog0 = sprintf('Extracted HOG Feature ... ... ... (%d/%d) Done     !!!!', j, totalVideo);
    disp(prog0);
    
end
display('Extracted the HOG feature ... ');
save('C:\Users\T2-503-3\Desktop\testITQ\hog\person01_boxing_d1_uncomp.mat','temp')
display('Saved the HOG feature ... ');
