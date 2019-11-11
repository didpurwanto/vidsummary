%% Color feature
% Date : Nov/07/2017
% Input: keyframes.jpg (P6_Copy2Frames)
% Output: copy the frame to the folder (.jpg)
% Process: 

%% 
clc
clear
close all
tic;
srcFiles = dir('D:\CNN_img\matlab\demo\video_frame\OVP\v21\*.jpg'); % °ÆÀÉ¦W\ª`·N/
totalVideo = length(srcFiles);
feature_fc7 = [];

for i=1 : totalVideo
    
    filename = strcat('D:\CNN_img\matlab\demo\video_frame\OVP\v21\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4);
    jpgFilename = strcat(name, '.jpg');
    
    tic;
    im= imread(jpgFilename);
	toc;
%     im = imread('test_image/ms.jpg');


    %% RGB Distribution, cube
    rgb_distribution(im,'cube',5)
    %% RGB Distribution, sphere
    rgb_distribution(im,'sphere',5)
    %% HSV Distribution
    hsv_distribution(im,5)
    
    
end