%% Computing the similarity of the selected key frame
% Date : July/18/2017
% Input : selected key frame from Darwin
% Output : the score of the similarity
%% 
clc
clear
close all

%% Input file
tic;
srcFiles = dir('C:\Users\T2-503-3\Desktop\0803_vsumm\ma_min_50_sim\v20\*.jpg');
totalVideo = length(srcFiles);
ssim_temp =[];
for i=1 : totalVideo-1
    show = sprintf('     Load the video %s  \t (%d / %d)', srcFiles(i).name, i, totalVideo);       
    disp(show);

    filename = strcat('C:\Users\T2-503-3\Desktop\0803_vsumm\ma_min_50_sim\v20\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4);
    img1=imread(filename);
    filename_next = strcat('C:\Users\T2-503-3\Desktop\0803_vsumm\ma_min_50_sim\v20\',srcFiles(i+1).name);
    img2=imread(filename_next);
    [ssimval,ssimmap] = ssim(img2, img1); % ssim(a, ref);
    
    ssim_temp = [ssim_temp; ssimval];

end
 %% remove the identical frames
frame_temp = [];
ssim_temp_value = [];
for k=1:size(ssim_temp,1)
    
    if ssim_temp(k,1) > 0.6  % setting the threshold
%   if ssim_temp(k,1) > 0.55 & ssim_temp(k,1) < 0.96 | 0.97 < ssim_temp(k,1) % setting the threshold
        frame_temp = [frame_temp; k];
        ssim_temp_value = [ssim_temp_value; ssim_temp(k,1)]
    end
end
toc;

    
%% test similarity
% % img1=imread ('C:\Users\T2-503-3\Desktop\123\1578.jpg');
% % img2=imread ('C:\Users\T2-503-3\Desktop\123\1680.jpg');
% % [ssimval,ssimmap] = ssim(img1, img2);