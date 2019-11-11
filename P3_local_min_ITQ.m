%% Find local min point
% Date : June/27/2017
% Input: feature_score.mat (P4_DW_Ma)
% Output: score (.mat)
% Process: A moving-average filter is a common method used for smoothing noisy data.
%           ( done-June/28 ) Ori -> DFT -> Low-pass filter -> IDFT -> local
%           min
%% 
clc
clear
close all
tic;
%% Input file
srcFiles = dir('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_2\ma\*.mat');
totalVideo = length(srcFiles);

srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\2\*.mat');
totalVideo_index = length(srcFiles_index);

test = 1;
%% 2017/ 4/10
for j = test : totalVideo   % load the file
    frame_distane = 100;                     % parameter of the paek distance
    howmany = 2;                            % 設定你要前幾個frame
    
    % --------------------- Loading the frame index number ---------------------
    filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\2\',srcFiles_index(j).name);
    name_index = srcFiles_index(j).name(1: end-4);
	display('Load index ... ');load(filename_index);
    
    % --------------------- Loading the Darwin Score ---------------------
    filename = strcat('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_2\ma\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    display('Load data ... ');load(filename);
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
    y = fft(score_fc7);
    score_fc7 = y;
    
% -------------------------------------------------------------------------
    WindowSize = 10;                                    %coff of the filter need
    filter_coeff = ones(1, WindowSize)/WindowSize;
    filter_output = filter(filter_coeff, 1, score_fc7);

% -------------------------------------------------------------------------
    y = ifft(filter_output);
    score_fc7 = y;

% -------------------------------------------------------------------------
    %% Find the point
    score_fc7 = real(score_fc7);
    video_frame = (1:a)';
	[pks,locs] = findpeaks(score_fc7','MinPeakDistance',frame_distane); 
    
    Data_score_s41 = 1.01*max(score_fc7) - score_fc7;
    [Minima,MinIdx] = findpeaks(Data_score_s41,'MinPeakDistance',frame_distane);
    Minima = score_fc7(MinIdx);
    
    
%     plot(video_frame,(score_s41)',video_frame(locs),pks,'or')
% % %     figure
% % %     plot(video_frame,(score_fc7)',video_frame(MinIdx),Minima,'or')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Peaks')
% % %     legend('Value ','peak')
    
    
    actual_frame_all = MinIdx;
    
     %% Actural frame from frame index
     actual_frame_all_temp = actual_frame_all;
     clear actual_frame_all
     actual_frame_all = [];
          
     for TT=1 : size(actual_frame_all_temp,2)
         temp_index = HammDis_select(actual_frame_all_temp(:,TT),1);
         actual_frame_all = [actual_frame_all; temp_index];
     end
 
    % save the frame_index 
    save(['D:\CNN_img\matlab\demo\darwin_OVP\HammDist\Bit64_It100_2\ma_min_index/' name '.mat'], 'actual_frame_all');
end






