%% Copy 2 Frames
% Date : Nov/07/2017
% Input: index.mat (P4_SNIP_ITQ)
% Output: copy the frame to the folder (.jpg)
% Process: 
%% 
clc
clear
close all
tic;
%% Input file
srcFiles_index = dir('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\all\Bit64_It100_512\ma_Max_index\*.mat');
% srcFiles_index = dir('./darwin_OVP/HammDist/pre_5/test_4/Bit64_It100_256/ma_Max_index/*.mat');
totalVideo_index = length(srcFiles_index);

test = 12;

for j = test : totalVideo_index  % load the file
    filename_ind = strcat('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\all\Bit64_It100_512\ma_Max_index\',srcFiles_index(j).name);
%     filename_ind = strcat('./darwin_OVP/HammDist/pre_5/test_4/Bit64_It100_256/ma_Max_index/',srcFiles_index(j).name);
    name_ind = srcFiles_index(j).name(1: end-4);
    display('Load Index ... ');
    ind_Filename = strcat(name_ind,'.mat');
    load(filename_ind); % input Hamming select 'actual_frame_all'
    
	srcFiles = dir(['D:\Dataset\SumMe\frame\',name_ind,'\*.jpg']);   % input indexê场紇image
% %     srcFiles = dir(['D:\CNN_img\matlab\demo\video_frame\VSUMM_Train\',name_ind,'\*.jpg']);   % input indexê场紇image
% %     srcFiles = dir(['./video_frame/OVP/',name_ind,'/*.jpg']);   % input indexê场紇image
	totalVideo = length(srcFiles);

    mkdir('D:\Results_work\SumMe\SNIP\All\pre_5\ma\1_256',name_ind);       % ミ紇戈Жframe
    

    for JJ=1 : size(actual_frame_all,1)
        
        kk = actual_frame_all(JJ,1); % 眔硂场紇 index 
        filename_jpg = strcat('D:\Dataset\SumMe\frame\',name_ind,'\',srcFiles(kk).name); % ê眎frame
        name = srcFiles(kk).name(1: end-4);
        display('Load image ... ');
        jpg_Filename = strcat(name,'.jpg');
    
        Img = imread(filename_jpg);
        % 糶ê眎frame﹚戈Ж
        imwrite(Img,strcat('D:\Results_work\SumMe\SNIP\All\pre_5\ma\1_256\',name_ind,'\',name,'.jpg')); 
    end
end
toc;