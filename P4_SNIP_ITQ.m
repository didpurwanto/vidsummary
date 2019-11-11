%% SVIP with DFT IDFT for Finding the width of the Peak ITQ
% Date : Oct/18/2017
% Input: feature_score.mat (P2_Darwin_HamDist.m)
% Output: Keyframe_index.mat
% Process: Input Darwin value --> DFT --> Filter --> IDFT --> Limit iteration --> SNIP
%% 
clc
clear
close all
tic;
%% Input file
% % srcFiles = dir('D:\CNN_img\matlab\demo\darwin_vsumm\HammDist\pre_5\test_1\Bit64_It100_512\ma\*.mat'); % VSUMM
% % srcFiles = dir('D:\CNN_img\matlab\demo\darwin_OVP\HammDist\pre_5\test_2\Bit64_It100_512\ma\*.mat'); % OVP
srcFiles = dir('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\test_1\Bit64_It100_512\ma\*.mat'); % SumMe
totalVideo = length(srcFiles);

% Hamming distance index
% % srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\vsumm\Bit_64\IT_100\pre_5\test_1\1_512\*.mat');
% % srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\pre_5\test_2\1_512\*.mat');
srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\SumMe\Bit_64\IT_100\pre_5\test_1\1_512\*.mat');
totalVideo_index = length(srcFiles_index);
test = 1;


%% 2017/ 4/10
for j = 1 : 1     % load the file
    frame_distane = 200;                    % parameter of the paek distance
    howmany = 2;                            % 設定你要前幾個frame
    
	% --------------------- Loading the Darwin Score ---------------------
    filename = strcat('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\test_1\Bit64_It100_512\ma\',srcFiles(j).name);
    name = srcFiles(j).name(1: end-4);
    display('Load data ... ');load(filename);
    
	% --------------------- Loading the frame index number ---------------------
    % darwin後的結果 取出的peak location需對應到原先ITQ select的index
    filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\SumMe\Bit_64\IT_100\pre_5\test_1\1_512\',srcFiles_index(j).name);
    name_index = srcFiles_index(j).name(1: end-4);
	display('Load index ... ');load(filename_index);
    
    %% ---------------  temp ---------------
    [a,b] = size(score_fc7);
    score = [];
    temp_nan = [];
    for m = 1 : a       % normalize 
        temp = score_fc7(m,:);      % put the feature into temp
        score = [score; temp];
    end

    % --------------------- Check the NAN number in data ---------------------
    temp_nan = find(isnan(score));                      % find out the nan element
    [a_nan,b_nan] = size(temp_nan);                     % a_nan is the number of NaN
    for n = 1 : a_nan    % nan 2 int
        score(temp_nan(n,b_nan),1) = isnan(score(temp_nan(n,b_nan),1)); % NaN is true NaN == 1;
        score(temp_nan(n,b_nan),1) = 0;                                 % NaN = 0
    end
    score_fc7 = double(score);
    
    % -------------------------------------------------------------------------
    % Discrete Fourier Transform
    y = fft(score_fc7);
    score_fc7 = y;

    % -------------------------------------------------------------------------
    % Moving-Average Filter
    WindowSize = 10;                                    %coff of the filter need
    filter_coeff = ones(1, WindowSize)/WindowSize;
    filter_output = filter(filter_coeff, 1, score_fc7);          

    % -------------------------------------------------------------------------
    % Inverse Discrete Fourier Transform
    y = ifft(filter_output);
    score_fc7 = y;
    
% % %     figure  % plot 傅立葉轉換後的結果圖
% % %     plot(1:a,score_fc7);
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title(' The score of IDFT ')
% % %     legend('IDFT ')
   
    % -------------------------------------------------------------------------
%     line([47,47],[min(score_fc7),max(score_fc7)]);    % 畫直線

    % -------------------------------------------------------------------------
    % Find the key point
    score_fc7 = real(score_fc7);
    video_frame = (1:a)';
	[pks,locs] = findpeaks(score_fc7','MinPeakDistance',frame_distane); 
    
    %---------------plot the original setting figure--------------- (show)
% % %     figure
% % %     plot(video_frame,(score_fc7)',video_frame(locs),pks,'or')
% % % %     plot(video_frame,(score_fc7)')
% % %     axis tight
% % %     ylabel('Precision Value')
% % %     xlabel('Frame Number')
% % %     title('Find All Peaks')
% % %     legend('Value ','peak')

    %%  Find the local min_valley
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


	% --------------------- Computing the sliding window ---------------------
    % Gaussian Filter to define the sliding window
    
% %     sigma = std(score_fc7);
% %     mm = mean(score_fc7);
% %     x = score_fc7;
% %     gaussFilter = exp(-((x-mm).^ 2)/ (2 * sigma ^ 2));
% %     gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% %     range = ceil(max(gaussFilter));
    
%     sigma = 5;
%     gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
%     gaussFilter = gaussFilter / sum (gaussFilter); % normalize
%     
%     y = rand(a,1);
%     yfilt = filter (gaussFilter,1, y);
%     yfilt = conv (y, gaussFilter, 'same');
    
    % --------------------- Computing the sliding window ---------------------
    percentage = 0.15;  % 0.15
    sldingwindow = percentage*a; 
    range = floor(sldingwindow);
    if range <= 100
        range = 100;
    end
    if range >= 500
        range = 500;
    end
% % range = 100;
%---------------SNIP---------------
% 前後range的平均來做比較 iteration後求出一條新的curve
% 由新的curve和舊的score來做比較
% 重合區域的交界線為我所要

final = [];         % how to define the best 
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

%---------------plot the figure---------------
    figure
    plot(video_frame,(score_fc7)','r',video_frame,(final)','k')
%     plot(video_frame,(score_fc7)','r',video_frame,(final)','k',video_frame(locs),pks,'or') % 含原先的peak
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','New Algorithm')

%---------------compute the range we want---------------
% 求出兩條curve的重合區域
% 因為我們只要最接近peak 的區域就好

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
% 畫出直線 以之後求出的重合區域為基準
for i=1 : size(range_point,1) 
    range_frame = range_point(i,1);
    line([range_frame,range_frame],[min(score_fc7),max(score_fc7)]);
end

%---------------Compute the peak---------------
% 計算出SNIP求出的區域 大約分哪幾區
% 有相近的界線
% 則取第一條當分界區域
peak_distance = [];
before_temp = 0;    % initial
for i=1 : size(range_point,1)
    if floor(range_point(i,1)/100) < 1      % 如果界線小於100 則存起那點
        peak_distance = [peak_distance; range_point(i,1)];
    else                                    % 如果界線大於100 則存起那點
        temp = floor(range_point(i,1)/100); 
    end
    
    if temp ~= before_temp                  % 如果此點與前一點的數值不一樣，代表他們不同區間(百位數不一樣)
        peak_distance = [peak_distance; range_point(i,1)];
    end
    before_temp = temp;                     % 存放此點的數值
end

pks_snip = [];
locs_snip = [];
peak_width_start = 1;                       % 從1開始
for i=1 : size(peak_distance,1)
    
    peak_width = peak_distance(i,1);        % 從第 i 個界線開始
    
    snip_distane = peak_distance(i,1)-peak_width_start-1;   % 從start到第 i 個界線開始
    score_fc7 = real(score_fc7);
    temp_score = score_fc7(peak_width_start:peak_width,1);  % 從start到第 i 個界線的值
    video_frame_temp = (peak_width_start:peak_width)';
	[pks_temp,locs_temp] = findpeaks(temp_score','MinPeakDistance',snip_distane); 
      
    pks_snip = [pks_snip pks_temp];
    locs_snip = [locs_snip (locs_temp+peak_width_start)-1];
    
    peak_width_start = peak_width;                          % 第 i 個界設成start，當下一個迴圈的開始start
end

    % 從最後一條界線到最後 a為資料全長
    snip_distane = a-peak_width_start-1;
    temp_score = score_fc7(peak_width_start:a,1);
    video_frame_temp = (peak_width_start:a)';
    [pks_temp,locs_temp] = findpeaks(temp_score','MinPeakDistance',snip_distane);
      
    pks_snip = [pks_snip pks_temp];
    locs_snip = [locs_snip (locs_temp+peak_width_start)-1];

%---------------snip and peak the figure---------------(show)
    figure
% %     plot(video_frame,(score_fc7)',video_frame(locs_snip),pks_snip,'or')
    plot(video_frame,(score_fc7)','r',video_frame,(final)','k',video_frame(locs_snip),pks_snip,'or') % score new_curve new_peak
    axis tight
    ylabel('Precision Value')
    xlabel('Frame Number')
    title('Find All Peaks')
    legend('Value ','peak')
    
%---------------line the figure---------------
% 畫出直線區域
% % % for i=1 : size(range_point,1) % 畫出直線 以之後求出的重合區域為基準
% % %     range_frame = range_point(i,1);
% % %     line([range_frame,range_frame],[min(score_fc7),max(score_fc7)]);
% % % end    


     %% Actural frame from frame index
     % 實際對上正確的frame number
     actual_frame_all = locs_snip';
     actual_frame_all_temp = actual_frame_all;
     clear actual_frame_all
     actual_frame_all = [];
          
     for TT=1 : size(actual_frame_all_temp,2)
         temp_index = HammDis_select(actual_frame_all_temp(:,TT),1);
         actual_frame_all = [actual_frame_all; temp_index];
     end     
     
     %% Save the file
     %%% OVP dataset
% % %     save(['D:\CNN_img\matlab\demo\darwin_OVP\HammDist\pre_5\test_3\Bit64_It100_256\ma_Max_index/' name '.mat'], 'actual_frame_all');
     %%% VSUMM dataset
% % %     save(['D:\CNN_img\matlab\demo\darwin_vsumm\HammDist\pre_5\test_3\Bit64_It100_256\ma_Max_index/' name '.mat'], 'actual_frame_all');
    %%% SumMe dataset
    save(['D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\test_1\Bit64_It100_512\ma_Max_index/' name '.mat'], 'actual_frame_all');
end
