%% Moving-Average Filter
% Date : Apr/10/2017
% Input: feature_score.mat (P4_DW_Ma)
% Output: DFT // Low-pass filter // IDFT (.mat)
% Process: A moving-average filter is a common method used for smoothing noisy data.
%           ( done-Apr/14 ) Ori -> DFT -> Low-pass filter -> IDFT
%           ( done-Apr/16 ) Peak point detection
%% 
clc
clear
close all
tic;
%% Input file
srcFiles = dir('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_1024\ma\*.mat');
totalVideo = length(srcFiles);

srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\1_1024\*.mat');
totalVideo_index = length(srcFiles_index);

%% 2017/ 4/10
for j = 1 : 1   % load the file
    frame_distane = 100;                    % parameter of the paek distance
    howmany = 2;                            % �]�w�A�n�e�X��frame
    
	% --------------------- Loading the Darwin Score ---------------------
    filename = strcat('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_1024\ma\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    display('Load data ... ');load(filename);
    
	% --------------------- Loading the frame index number ---------------------
    % darwin�᪺���G ���X��peak location�ݹ�������ITQ select��index
    filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\1_1024\',srcFiles_index(j).name);
    name_index = srcFiles_index(j).name(1: end-4);
	display('Load index ... ');load(filename_index);
    
    %% ---------------  end ---------------
    [a,b] = size(score_fc7);
    score = [];
    temp_nan = [];
    for m = 1 : a       % normalize 
        temp = score_fc7(m,:);                          % put the feature in temp
        score = [score; temp];
    end
% -------------------------------------------------------------------------
    temp_nan = find(isnan(score));                      % find out the nan element
    [a_nan,b_nan] = size(temp_nan);                     % a_nan is the number of NaN
    for n = 1 : a_nan    % nan 2 int
        score(temp_nan(n,b_nan),1) = isnan(score(temp_nan(n,b_nan),1)); % NaN is true NaN == 1;
        score(temp_nan(n,b_nan),1) = 0;                                 % NaN = 0
    end
    score_fc7 = double(score);
% -------------------------------------------------------------------------
%     figure
%     plot(1:a, score_s41);                               % frame length // value
%     axis tight
%     ylabel('Precision Value')
%     xlabel('Frame Number')
%     title(' The score of Rank Pooling ')
%     legend('Original score')
% -------------------------------------------------------------------------
    y = fft(score_fc7);
    score_fc7 = y;
%     figure
%     plot(1:a,score_s41)
%     axis tight
%     legend('DFT')
%     ylabel('Precision Value')
%     xlabel('Frame Number')
%     title(' The score of DFT ')
% -------------------------------------------------------------------------
    WindowSize = 10;                                    %coff of the filter need
    filter_coeff = ones(1, WindowSize)/WindowSize;
    filter_output = filter(filter_coeff, 1, score_fc7);           % -------------

%     figure
%     plot(1:a,[score_s41 filter_output])
%     axis tight
%     legend('DFT','Filter out')
%     ylabel('Precision Value')
%     xlabel('Frame Number')
%     title(' The score of Low-pass filter ')
% -------------------------------------------------------------------------
    y = ifft(filter_output);
    score_fc7 = y;
% %     figure
% %     plot(1:a, score_s41);
% %     axis tight
% %     ylabel('Precision Value')
% %     xlabel('Frame Number')
% %     title(' The score of IDFT ')
% %     legend('IDFT ')
% -------------------------------------------------------------------------
    %% Find the peak point
    score_fc7 = real(score_fc7);                                % ����Ƴ���
    % findpeaks(score_s41,a)
    video_frame = (1:a)';
    total = sum(score_fc7);
    A_mean = (total/a) ;
    A_std = std(score_fc7);

% Find the peaks that are at least 1 V higher than their neighboring samples.
    
%     [pks,locs] = findpeaks(score_s41');                           % ����peak
%     [pks_thre,locs_thre] = findpeaks(score_s41','threshold',2*A_mean,'MinPeakDistance',frame_distane); 	% ����F��˫~���ܤ� X ���p�C
%     [pks,locs] = findpeaks(score_s41','MinPeakHeight',10);                 % ��찪�ܤ� X ���p
    [pks,locs] = findpeaks(score_fc7','MinPeakDistance',frame_distane);        % �C�j100
    
   
    %-----plot the figure-----
    figure
    plot(video_frame,(score_fc7)',video_frame(locs),pks,'or')
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','peak')
% -------------------------------------------------------------------------
    pks_d = [];
    locs_temp = [];
    for k=1 :  size(locs,2)         % �p��Ҧ�peak���ƭȮt��(�P�e�@�i����۴�)
        locs_temp = locs(1,k);
        pks_temp = score_fc7(locs_temp,1) - score_fc7(locs_temp-1,1);
        pks_d = [pks_d pks_temp];
    end
    [pks_d_sort, pks_d_loc] = sort(pks_d, 'descend'); % �ƧǩҦ�peak���t�ȡA�Ѥj��p
    locs_ans = [];              % _ans�̫�Ψ�plot figure
    pks_ans = [];               % _ans�̫�Ψ�plot figure
    for w = 1 : howmany 
        locs_t = locs(1,pks_d_loc(1,w));
        locs_ans = [locs_ans locs_t];
        pks_t = score_fc7(locs_t,1);
        pks_ans = [pks_ans pks_t];
    end
    actual_frame_ans = locs_ans;
    actual_frame_all = locs;
    % --------------------- Select the actural frame ---------------------
   
     %% Actural frame from frame index
     actual_frame_all_temp = actual_frame_all;
     clear actual_frame_all
     actual_frame_all = [];
          
     for TT=1 : size(actual_frame_all_temp,2)
         temp_index = HammDis_select(actual_frame_all_temp(:,TT),1);
         actual_frame_all = [actual_frame_all; temp_index];
     end
    
    % save the frame_index 
    save(['D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_1024\ma_Max_index/' name '.mat'], 'actual_frame_all');
end
toc;
