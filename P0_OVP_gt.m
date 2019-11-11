%% OVP dataset ground-truth
% Date : Nov/07/2017
% Input: keyframes.jpg (P6_Copy2Frames)
% Output: copy the frame to the folder (.jpg)
% Process: 
%% 
clc
clear
close all
tic;

srcFiles = dir('D:\Dataset\OVP_Train\OVP_GT_gif\*.isdir');
totalVideo = length(srcFiles);

Home_folder = './OVP_Train/OVP_GT_gif/';
Home_image = '.OVP_Train/frames/';

for i=1:50
    
%     videoList=dir([HOMEVIDEOS '/*.webm']);
    srcFiles = dir([Home_folder name_ind,'\*.jpg']);   % input index那部影片的原image
	totalVideo = length(srcFiles);

    display(123);
end