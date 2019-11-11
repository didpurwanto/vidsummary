%% Convert images to video
clc
clear
close all
tic;
%% Input file
% ITQ-HamminDistance selecet index
srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\2\*.mat');
totalVideo_index = length(srcFiles_index);

srcFiles = dir('D:\CNN_img\matlab\demo\video_frame\OVP_DT\AmericasNew_Frontier_seg4\*.jpg');
totalVideo = length(srcFiles);

%%  paremeter creat the video need ...
% Create a video writer object
writerObj = VideoWriter('Video.avi');
% Set frame rate
writerObj.FrameRate = 30;
% Open video writer object and write frames sequentially
open(writerObj)

test = 5;

for JJ=test : test
    filename_ind = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\2\',srcFiles_index(JJ).name);
    name_ind = srcFiles_index(JJ).name(1: end-4);
    display('Load Index ... ');
    ind_Filename = strcat(name_ind,'.mat');
    load(filename_ind);
    
    for kk = 1:size(HammDis_select,1)                   % Some number of frames
        
        TT = HammDis_select(kk,1);
% % %         TT = actual_frame_all(kk,1);
        % Read frame
        filename_jpg = strcat('D:\CNN_img\matlab\demo\video_frame\OVP_DT\AmericasNew_Frontier_seg4\',srcFiles(TT).name);
        name_jpg = srcFiles(TT).name(1: end-4);
        display('Load image ... ');
        jpg_Filename = strcat(name_jpg,'.jpg');

        Img = imread(filename_jpg);

        % Write frame now  
        writeVideo(writerObj,Img);
        
        clear inputput;
    end
end

% Close the video writer object
close(writerObj);
toc;
