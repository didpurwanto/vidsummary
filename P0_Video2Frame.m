%% Extracted the frame per video and saving all frames 
% Date : Mar/09/2017
% Input : video.avi
% Output : frame.jpg
%% 
clc
clear
close all
%% Input file
srcFiles = dir('D:\Dataset\VSUMM_Train\VSUMM_Train\*.avi');
totalVideo = length(srcFiles);
%% 
for k=27 :27
    show = sprintf('     Load the video %s  \t (%d / %d)', srcFiles(k).name, k, totalVideo);       
    disp(show);
    filename = strcat('D:\Dataset\VSUMM_Train\VSUMM_Train\',srcFiles(k).name);
    name = srcFiles(k).name(1: end-4);
    
    source = VideoReader(filename);
    frame = source.Numberofframes;
    
    mkdir('D:\Dataset\VSUMM_Train\frames',name); % 建立此影片的資料夾存frame
    
    for i=1 : source.NumberOfFrames-1;  % 儲存video的frames
        filename = strcat('frame',num2str(i),'.jpg');
        image_read = read(source, i); 
%         imwrite(image_read,strcat('D:\TDD\TDD\video_frame\brush_hair_1\',num2str(i),'.jpg'));
        imwrite(image_read,strcat('D:\Dataset\VSUMM_Train\frames\',name,'\' ,num2str(i),'.jpg'));
    end
end