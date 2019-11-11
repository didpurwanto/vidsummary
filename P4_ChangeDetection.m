%% Change Detection with DFT IDFT
% Date : Oct/18/2017
% Input: feature_score.mat (P2_Darwin)
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
srcFiles = dir('D:\CNN_img\matlab\demo\darwin_OVP\ma\*.mat');
totalVideo = length(srcFiles);
test = 5;
%% 2017/ 4/10
for j = test : test   % load the file
    frame_distane = 100;                     % parameter of the paek distance
    howmany = 2;                            % 設定你要前幾個frame
    
    filename = strcat('D:\CNN_img\matlab\demo\darwin_OVP\ma\',srcFiles(j).name);
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
    filter_output = filter(filter_coeff, 1, score_fc7);           % -------------

% -------------------------------------------------------------------------
    y = ifft(filter_output);
    score_fc7 = y;

% -------------------------------------------------------------------------
    %% Find the point
    score_fc7 = real(score_fc7);
    video_frame = (1:a)';
	[pks,locs] = findpeaks(score_fc7','MinPeakDistance',frame_distane); 
   
    %%  Find the local min
% %     Data_score_s41 = 1.01*max(score_fc7) - score_fc7;
% %     [Minima,MinIdx] = findpeaks(Data_score_s41,'MinPeakDistance',frame_distane);
% %     Minima = score_fc7(MinIdx);
    
%---------------plot the figure---------------
    figure
    plot(video_frame,(score_fc7)',video_frame(locs),pks,'or')
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','peak')


%     plot(video_frame,(score_s41)',video_frame(locs),pks,'or')
% % %     figure
% % %     plot(video_frame,(score_fc7)',video_frame(MinIdx),Minima,'or')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Peaks')
% % %     legend('Value ','peak')
        
%---------------Change Detection---------------
%%
y_change = score_fc7';

figure
% % % % load logwell.mat
% choice of alpha
alpha = .01;

n = 75; %50
k = 10; %10
subplot(2,1,1)
plot(y_change')
axis([1,size(y_change,2),-inf,inf])
%%
score1 = change_detection(y_change,n,k,alpha,5);
score2 = change_detection(y_change(:,end:-1:1),n,k,alpha,5);
%%
subplot(2,1,1);
plot(y_change', 'linewidth',2);
axis([-inf,size(y_change,2),-inf,inf])
title('Original Signal')
%%
subplot(2,1,2);
score2 = score2(end:-1:1);

% 2*n-2+k is the size of buffer zone
plot([zeros(1,2*n-2+k),score1 + score2], 'r-', 'linewidth',2);
axis([-inf,size(y_change,2),-inf,inf])
title('Change-Point Score')

    %---------------Peak Detection Again---------------
    score_again = (score1 + score2)';
    score_again = real(score_again);
    [a_2,b_2] = size(score_again);
    video_frame_again = (1:a_2)';
	[pks_2,locs_2] = findpeaks(score_again','MinPeakDistance',frame_distane);
    
    figure
    plot(video_frame_again,(score_again)',video_frame_again(locs_2),pks_2,'or')
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Local Max from Change Detection')
    legend('Value ','peak')

    %---------------Inverse Peak Detection Again---------------
% % %     score_again = (score1 + score2)';
% % %     score_again = real(score_again);
% % %     Data_score_again = 1.01*max(score_again) - score_again;
% % %     [a_min,b_min] = size(Data_score_again);
% % %     video_frame_again = (1:a_min)';
% % % 	[pks_min,locs_min] = findpeaks(Data_score_again','MinPeakDistance',frame_distane);  
% % %     
% % %     figure
% % %     plot(video_frame_again,(score_again)',video_frame_again(locs_min),pks_min,'or')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Local Min from Change Detection')
% % %     legend('Value ','peak')
    
     %% Save the file
% % %     save(['D:\CNN_img\matlab\demo\darwin_OVP\ma_min_index/' name '.mat'], 'actual_frame_all');
end
