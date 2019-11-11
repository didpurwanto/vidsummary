%% SVIP with DFT IDFT for Finding the width of the Peak
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
test = 4;
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
%---------------plot the figure---------------
% % %     figure
% % % %     plot(video_frame,(score_fc7)',video_frame(locs),pks,'or')
% % %     plot(video_frame,(score_fc7)')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Peaks')
% % %     legend('Value ','peak')

    %%  Find the local min
% %     Data_score_s41 = 1.01*max(score_fc7) - score_fc7;
% %     [Minima,MinIdx] = findpeaks(Data_score_s41,'MinPeakDistance',frame_distane);
% %     Minima = score_fc7(MinIdx);

%     plot(video_frame,(score_s41)',video_frame(locs),pks,'or')
% % %     figure
% % %     plot(video_frame,(score_fc7)',video_frame(MinIdx),Minima,'or')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Peaks')
% % %     legend('Value ','peak')
        
%---------------SNIP---------------
% 前後range的平均來做比較 求出一條新的curve
% 由新的curve和舊的score來做比較
% 重合區域的交界線為我所要
final = [];
range = 100;                                 % how to define the best 
final = [final; score_fc7(1:range,1)];
for i=1+range:size(score_fc7,1)-range
    aaa = score_fc7(i,1);
    bbb = (score_fc7(i-range,1)+score_fc7(i+range,1))/2;
    
    if bbb < aaa
        final = [final; bbb];
    else
        final = [final; aaa];
    end
end
final = [final; score_fc7(end-range+1:end,1)];

    figure
    plot(video_frame,(score_fc7)','r',video_frame,(final)','k')
%     plot(video_frame,(score_fc7)','r',video_frame,(final)','k',video_frame(locs),pks,'or') % 含原先的peak
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','New Algorithm')

%---------------plot the figure---------------
range_point = [];
before_count = [];
count = -1;     % 一開始一樣 相減為零 設負號
for i=1 :size(score_fc7,1)
    before_count = count;
    if sum(abs(score_fc7(i,1)-final(i,1))) ~= 0 % 相減不為零 設正號
        count = 1;
    else
        count = -1;
    end
    if sign(count) ~= before_count              % 如有變號 則記錄下該點
        range_point = [range_point; i];
    end
end
%---------------line the figure---------------
% % % for i=1 : size(range_point,1) % 畫出直線 以之後求出的重合區域為基準
% % %     range_frame = range_point(i,1);
% % %     line([range_frame,range_frame],[min(score_fc7),max(score_fc7)]);
% % % end

%---------------Compute the peak---------------
% 計算出SNIP求出的區域 大約分那幾區
% 有相近的 則取第一條當分界區域
peak_distance = [];
before_temp = 0; % initial
for i=1 : size(range_point,1)
    if floor(range_point(i,1)/100) < 1
        peak_distance = [peak_distance; range_point(i,1)];
    else
        temp = floor(range_point(i,1)/100);
    end
    
    if temp ~= before_temp
        peak_distance = [peak_distance; range_point(i,1)];
    end
    before_temp = temp;
   
end
pks_snip = [];
locs_snip = [];
peak_width_start = 1; % 從1開始
for i=1 : size(peak_distance,1)
    
    peak_width = peak_distance(i,1);
    
%     snip_distane = 160;
    snip_distane = peak_distance(i,1)-peak_width_start-1;
    score_fc7 = real(score_fc7);
    temp_score = score_fc7(peak_width_start:peak_width,1);
    video_frame_temp = (peak_width_start:peak_width)';
	[pks_temp,locs_temp] = findpeaks(temp_score','MinPeakDistance',snip_distane); 
      
    pks_snip = [pks_snip pks_temp];
    locs_snip = [locs_snip (locs_temp+peak_width_start)-1];
    
    peak_width_start = peak_width;
end

    % 從最後一條界線到最後 a為資料全長
    snip_distane = a-peak_width_start-1;
    temp_score = score_fc7(peak_width_start:a,1);
    video_frame_temp = (peak_width_start:a)';
    [pks_temp,locs_temp] = findpeaks(temp_score','MinPeakDistance',snip_distane);
      
    pks_snip = [pks_snip pks_temp];
    locs_snip = [locs_snip (locs_temp+peak_width_start)-1];

%---------------snip and peak the figure---------------
    figure
% %     plot(video_frame,(score_fc7)',video_frame(locs_snip),pks_snip,'or')
    plot(video_frame,(score_fc7)','r',video_frame,(final)','k',video_frame(locs_snip),pks_snip,'or') % score new_curve new_peak
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','peak')
%---------------line the figure---------------
for i=1 : size(range_point,1) % 畫出直線 以之後求出的重合區域為基準
    range_frame = range_point(i,1);
    line([range_frame,range_frame],[min(score_fc7),max(score_fc7)]);
end    

    actual_frame_all = locs_snip';

     %% Save the file
%     save(['D:\CNN_img\matlab\demo\darwin_OVP\ma_min_index/' name '.mat'], 'actual_frame_all');
    save(['D:\CNN_img\matlab\demo\darwin_OVP\SNIP\ma_Max_snip_index/' name '.mat'], 'actual_frame_all');
end
