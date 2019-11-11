%% Random select video
% Date : Sep/07/2017
% Input: 
% Output: 
% Process: Random select train / test video
%% 
clc
clear
close all
tic;
%% -----------------------------------------------------------------------------
tic;
disp('Random ...');
Random_data = randperm(50)'; % 隨機排列 X 
data_index = Random_data(1:40); 
toc;
%% -----------------------------------------------------------------------------
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7_ovp\*.mat');
totalVideo = length(srcFiles);

ovp_all = [];
for i=1:size(data_index,1)
    
    k = data_index(i,1);
    % --------------------- Loading the Darwin Score ---------------------
	filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7_ovp\',srcFiles(k).name);
	name = srcFiles(k).name(1: end-4);
    load(filename);
    
    [a b] = size(feature_fc7);
    show_step = sprintf('     Processing %s length \t %d \t (%d / %d)', srcFiles(k).name, b, k, totalVideo);
    disp(show_step);

    temp = double(feature_fc7');
    ovp_all = [ovp_all; temp];
    
    display('Load data ... ');
end

%% -----------------------------------------------------------------------------
%% -----------------------------------------------------------------------------
tic;
disp('Random ...');
Random_data = randperm(31)'; % 隨機排列 X 
data_index = Random_data(1:8); 
toc;