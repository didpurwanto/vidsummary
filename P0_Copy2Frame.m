%% Find local min point
% Date : Sep/27/2017
% Input: index.mat (P2_Peak)
% Output: copy the frame to the folder (.mat)
% Process: 
%% 
clc
clear
close all
tic;
%% Input file
srcFiles_index = dir('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_1024_40\if_Max_index\*.mat');
totalVideo_index = length(srcFiles_index);

srcFiles = dir('D:\CNN_img\matlab\demo\video_frame\OVP_DT\ANew_Horizon_seg5\*.jpg');
totalVideo = length(srcFiles);
test = 1;
for j = test : test   % load the file
    filename_ind = strcat('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_1024_40\if_Max_index\',srcFiles_index(j).name);
    name_ind = srcFiles_index(j).name(1: end-4);
    display('Load Index ... ');
    ind_Filename = strcat(name_ind,'.mat');
    load(filename_ind);
    
    for JJ=1 : size(actual_frame_all,1)
        
        kk = actual_frame_all(JJ,1);
        
        filename_jpg = strcat('D:\CNN_img\matlab\demo\video_frame\OVP_DT\ANew_Horizon_seg5\',srcFiles(kk).name);
        name = srcFiles(kk).name(1: end-4);
        display('Load image ... ');
        jpg_Filename = strcat(name,'.jpg');
    
        Img = imread(filename_jpg);
%         imwrite(Img,strcat('D:\Results_work\OVP_ITQ\ma_min\B64_It100_2\AmericasNew_Frontier_seg4\',name,'.jpg'));
        imwrite(Img,strcat('D:\Results_work\OVP_ITQ\SNIP\if_Max_1024_40\ANew_Horizon_seg5\',name,'.jpg'));
    end
end
