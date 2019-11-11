%%  Moving Averagev  
% Date : Mar/08/2017
% Input: Feature.mat (P4_DW_Key)
% Output: Darwin mean average per video  // score.mat
% Process : Compute [1,50] frame average and then compute [t,t+49] 
%           I write a new function that execute the different Rank pooling 
%           about moving average what difine the different range of per
%           video.
%% 
clc
clear
close all

%% Input file
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_SumMe\fc7\*.mat');
totalVideo = length(srcFiles);

for j = 1 : totalVideo
    % load the file 
    filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_SumMe\fc7\',srcFiles(j).name);
%     filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    tic;
    display('Load data ... ');load(filename);
    
    temp = feature_fc7'; 
    clear feature_fc7;
    feature_fc7 = temp;
    [a b] = size(feature_fc7);
    show_step = sprintf('     Processing %s length \t %d \t (%d / %d)', srcFiles(j).name, a, j, totalVideo);
    disp(show_step);
    % computing the moving average each video
    CVAL = 1;  
    ma_fc7 = VideoDarwin(feature_fc7,CVAL);
    ans_fc7 = ma_fc7(1:length(ma_fc7)/4)';
    score_fc7 = feature_fc7*ans_fc7';
    
    
    toc;
    % plot the fi
% % %     [c,d] = size(score_fc7);
% % %     disp('    PLOT the figure !!!'); 
% % %     feature_fc7 = figure;
% % %     plot(1:c,score_fc7);
% % %     grid on; xlabel('Frame Number'); ylabel('Precision Value');clear c; clear d;

    
    %% Save the file
%     save(['D:\CNN_img\matlab\demo\darwin_vsumm\if/' name '.mat'], 'score_fc7');
    save(['D:\CNN_img\matlab\demo\darwin_SumMe\without\if/' name '.mat'], 'score_fc7');
end
