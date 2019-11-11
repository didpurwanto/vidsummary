%% Darwin Hamming Distance 
% Date : Aug/09/2017
% Input: Feature_index.mat (P1_ITQ_train.m)
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
% % srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_vsumm\test_3\*.mat');  % VSUMM
% % srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7_ovp_test_3\*.mat'); % OVP
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_SumMe\fc7\*.mat'); % SumMe
totalVideo = length(srcFiles);

srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\SumMe\Bit_64\IT_100\pre_5\test_1\1_1024\*.mat'); % Hamming distance
totalVideo_index = length(srcFiles_index);

for j = 1 : totalVideo
    % --------------------- Loading the feature ---------------------
    filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_SumMe\fc7\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
	display('Load feature ... ');load(filename);
    
    % --------------------- Loading the index number ---------------------
    filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\SumMe\Bit_64\IT_100\pre_5\test_1\1_1024\',srcFiles_index(j).name);
    name_index = srcFiles_index(j).name(1: end-4);
	display('Load index ... ');load(filename_index);
    
    tic;    
    % --------------------- Select the index feature ---------------------  
    % 依照Hamming index而挑出相對的feature
    index_num= [];
    index_temp = [];
    feature_index_2 = [];
    for i=1 : size(HammDis_select,1)
        index_num = HammDis_select(i,:);        % load index number
        index_temp = feature_fc7(:,index_num);	% 挑出那個index的feature
        feature_index_2 = [feature_index_2 index_temp]; %
    end
    display('Stop ... ');
    
    % --------------------- Select the index feature --------------------- 
    clear feature_fc7;
    feature_fc7 = feature_index_2;
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
    % ------------------- plot the figure-----------------------
% % %     [c,d] = size(score_fc7);
% % %     disp('    PLOT the figure !!!'); 
% % %     feature_fc7 = figure;
% % %     plot(1:c,score_fc7);
% % %     grid on; xlabel('Frame Number'); ylabel('Precision Value');clear c; clear d;

    
    %% Save the file
    % saving the darwin score 
    save(['D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\test_1\Bit64_It100_1024\if/' name '.mat'], 'score_fc7');

end
