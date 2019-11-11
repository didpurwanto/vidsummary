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
srcFiles = dir('C:\Users\wenchi\Desktop\test_1206\OVP\v56_withoutITQ\*.mat'); % test VSUMM v77
% srcFiles = dir('D:\CNN_img\matlab\demo\darwin_OVP\ma\*.mat');
totalVideo = length(srcFiles);

% % % srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\*.mat');
% % % totalVideo_index = length(srcFiles_index);

test = 1;
%% 2017/ 4/10
for j = test : test   % load the file
    frame_distane = 150;                    % parameter of the paek distance
    howmany = 2;                            % 設定你要前幾個frame
    
	% --------------------- Loading the Darwin Score ---------------------
    filename = strcat('C:\Users\wenchi\Desktop\test_1206\OVP\v56_withoutITQ\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    display('Load data ... ');load(filename);
    
	% --------------------- Loading the index number --------------------- 
% % % 	filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\',srcFiles_index(j).name);
% % %     name_index = srcFiles_index(j).name(1: end-4);
% % %     display('Load index ... ');load(filename_index);
    
    
    %% --------------- Change point detection --------------- 
% % %     alpha = .01;        % alpha = 0.01
% % %     n = 50;
% % %     k = 10;             % sliding_window
% % %     y = score_s41';
% % %     score1 = change_detection(y,n,k,alpha,5);
% % %     score2 = change_detection(y(:,end:-1:1),n,k,alpha,5); % y(:,end:-1:1) Data頭尾全部顛倒
% % %     clear score_s41;
% % % %     score_s41 = (score1 + score2)';
% % %    score_s41 =  [zeros(1,2*n-2+k),score1 + score2]';
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
    figure
    plot(1:a, score_fc7);
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title(' The score of IDFT')
    legend('IDFT ')
% -------------------------------------------------------------------------
    %% Find the peak point
    score_fc7 = real(score_fc7);                                % 取實數部分
    % findpeaks(score_s41,a)
    video_frame = (1:a)';
    total = sum(score_fc7);
    A_mean = (total/a) ;
    A_std = std(score_fc7);

% Find the peaks that are at least 1 V higher than their neighboring samples.
    
%     [pks,locs] = findpeaks(score_s41');                           % 全部peak
%     [pks_thre,locs_thre] = findpeaks(score_s41','threshold',2*A_mean,'MinPeakDistance',frame_distane); 	% 找到比鄰近樣品高至少 X 的峰。
%     [pks,locs] = findpeaks(score_s41','MinPeakHeight',10);                 % 找到高至少 X 的峰
    [pks,locs] = findpeaks(score_fc7','MinPeakDistance',frame_distane);        % 每隔100
    
%---------------plot the figure---------------
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
    for k=1 :  size(locs,2)         % 計算所有peak的數值差異(與前一張比較相減)
        locs_temp = locs(1,k);
        pks_temp = score_fc7(locs_temp,1) - score_fc7(locs_temp-1,1);
        pks_d = [pks_d pks_temp];
    end
    [pks_d_sort, pks_d_loc] = sort(pks_d, 'descend'); % 排序所有peak的差值，由大到小
    locs_ans = [];              % _ans最後用來plot figure
    pks_ans = [];               % _ans最後用來plot figure
    for w = 1 : howmany 
        locs_t = locs(1,pks_d_loc(1,w));
        locs_ans = [locs_ans locs_t];
        pks_t = score_fc7(locs_t,1);
        pks_ans = [pks_ans pks_t];
    end
    actual_frame_ans = locs_ans;
    actual_frame_all = locs;
    
% -------------------------------------------------------------------------
    [frame_num,frame_dim] = size(score_fc7);
    p_rms = sum(score_fc7)/frame_num;
% %     line([0,frame_num],[p_rms,p_rms]) % 畫出總平均值
% %     
% %     line([100,100],[min(score_fc7),max(score_fc7)]) 
% %     line([200,200],[min(score_fc7),max(score_fc7)])
% %     line([300,300],[min(score_fc7),max(score_fc7)])
% %     line([400,400],[min(score_fc7),max(score_fc7)])
% %     line([500,500],[min(score_fc7),max(score_fc7)])
% %     line([600,600],[min(score_fc7),max(score_fc7)])
% %     line([700,700],[min(score_fc7),max(score_fc7)])
% %     line([800,800],[min(score_fc7),max(score_fc7)])
% %     line([900,900],[min(score_fc7),max(score_fc7)])
% %     line([1000,1000],[min(score_fc7),max(score_fc7)])
% %     line([1100,1100],[min(score_fc7),max(score_fc7)])
% %     line([1200,1200],[min(score_fc7),max(score_fc7)])
% %     line([1300,1300],[min(score_fc7),max(score_fc7)])
% %     line([1400,1400],[min(score_fc7),max(score_fc7)])
% %     line([1500,1500],[min(score_fc7),max(score_fc7)])
% %     line([1600,1600],[min(score_fc7),max(score_fc7)])
% %     line([1700,1700],[min(score_fc7),max(score_fc7)])
% %     line([1800,1800],[min(score_fc7),max(score_fc7)])
% %     line([1900,1900],[min(score_fc7),max(score_fc7)])
% %     line([2000,2000],[min(score_fc7),max(score_fc7)])
% %     line([2100,2100],[min(score_fc7),max(score_fc7)])
% %     line([2200,2200],[min(score_fc7),max(score_fc7)])
% -------------------------------------------------------------------------
    % 計算出全部的正負比 %

% %     figure
% %  	dutycycle(abs(score_fc7));
% %     dutycycle(score_fc7);

% --------------------- Select the actural frame --------------------------
    %% ITQ Results
% %     temp_index = [];
% %     ans_frame = [];
% %     for g=1:size(actual_frame_all,2)
% %         temp_index = actual_frame_all(:,g);
% %         ans_frame = [ans_frame B1_sim_index(temp_index,:)];
% %         
% %     end

% -------------------------------------------------------------------------
% % % % % % % %     figure
% % % % % % % %     plot(video_frame,(score_s41)',video_frame(locs_ans),pks_ans,'or')
% % % % % % % %     axis tight
% % % % % % % %     ylabel('Precision Value')
% % % % % % % %     xlabel('Frame Number')
% % % % % % % %     title('Find All Peaks')
% % % % % % % %     legend('Value ','peak')

% -------------------------------------------------------------------------
% %     d_max = []; % 求出每張frmae數值相差
% %     top_max = []; % 紀錄差值最大的locs
% %     top_value = [];
% %     actual_frame_all = [];
% %     actual_frame_top = [];
% %     for k=2 : size(score_s41,1)
% %         d = score_s41(k,1)-score_s41(k-1,1);
% %         d_max = [d_max; d];
% %     end
% % %     d_max = [d_max; d_max(end,1)];
% %     [max_num, max_loc] = sort(d_max, 'descend');
% %     top_max = sort(max_loc(1:10), 'ascend')+1;      % 因為相減所以frame的位置要+1
% %     for p = 1 : 10
% %         temp_value = score_s41(top_max(p,1),1);
% %         top_value = [top_value; temp_value];
% %     end
% %     figure
% %     plot(video_frame,(score_s41)',video_frame(top_max'),top_value','or')
% %     axis tight
% %     ylabel('Precision Value')
% %     xlabel('Frame Number')
% %     title('Find Top Points')
% %     legend('peak ')
% % 
% % %     actual_frame_all = locs+15;
% % %     actual_frame_top = top_max+15;
% -------------------------------------------------------------------------
% save(['D:\TDD\TDD\HMDB_8A_MA\lowpass_if/' name '.mat'], 'score_s41');
    
    %% Save the file
    temp = actual_frame_all';
    clear actual_frame_all
    actual_frame_all = temp;
    save(['C:\Users\wenchi\Desktop\test_1206\OVP\v56_withoutITQ\peak/' name '.mat'], 'actual_frame_all');
% % %     save(['D:\CNN_img\matlab\demo\darwin_OVP\if_Max_index/' name '.mat'], 'actual_frame_all');
end
toc;
