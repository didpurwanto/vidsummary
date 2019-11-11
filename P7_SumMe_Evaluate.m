%% SumMe dataset Evaluate Protocol
% Date : Feb/02/2018
% Input: actural_frames.jpg (P4_SNIP_Shot.m)
% Output: f-measure recall precision
% Process: 
%% 
clc
clear
close all
tic;

% Iitial 
Result_Precision = [];
Result_Recall = [];
Result_F_measure = [];

% Ground-truth
srcFiles_GT = dir('D:\CNN_img\matlab\demo\SumMe_GT\all\*.mat');
totalVideo_GT = length(srcFiles_GT);

% Keyframe_actualframe
srcFiles_index = dir('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\all\Bit64_It100_512\ma_Max_index\*.mat');
totalVideo_index = length(srcFiles_index);

test=3;

for i=test : test
    % Keyframe_actualframe
	filename_ind = strcat('D:\CNN_img\matlab\demo\darwin_SumMe\HammDist\pre_5\all\Bit64_It100_512\ma_Max_index\',srcFiles_index(i).name);
    name_ind = srcFiles_index(i).name(1: end-4);
    display('Load Index ... ');
    ind_Filename = strcat(name_ind,'.mat');
    load(filename_ind); % input Hamming select 'actual_frame_all'
    
    % Ground-truth
    filename_GT = strcat('D:\CNN_img\matlab\demo\SumMe_GT\all\',srcFiles_GT(i).name);
    name_GT = srcFiles_GT(i).name(1: end-4);
    display('Load Index ... ');
    GT_Filename = strcat(name_ind,'.mat');
    
    gt_data = load(filename_GT); % input Hamming select 'actual_frame_all'
    nFrames = length(gt_data.gt_score);
    GT_score = gt_data.gt_score;
    display('Load all data ... ')
    
    figure  % User 選出的分數
    plot(1:nFrames,GT_score);
    axis tight
    ylabel('Human Selection')
    xlabel('Frame')
    title('Human Selection on SumMe Dataset')
    legend('Score ')
    
    %--------------- precision ---------------%
    count = 0;
    for num = 1:size(actual_frame_all,1)
        GT_score_temp = GT_score(actual_frame_all(num,1),1);
        
        if GT_score_temp > 0
            count = count+1;
        end
        clear GT_score_temp
    end
    Precision = (count/num)*100;
    
	%--------------- recall ---------------%
    recall_sum = 0;
    count_recall = 0;
    count_recall_next = 0;
    for numnum = 1:size(GT_score,1)-1
        count_recall = GT_score(numnum,1);
        count_recall_next = GT_score(numnum+1,1);
        
        if count_recall ==0 &&  count_recall_next>0
            recall_sum = recall_sum+1;
        end
    end
    Recall = (count/recall_sum)*100;
    
    %--------------- f-measure ---------------%
    F_measure = (2*Precision*Recall)/(Precision+Recall);
    
    %--------------- Results ---------------%
    Result_Precision = [Result_Precision; Precision];
    Result_Recall = [Result_Recall; Recall];
    Result_F_measure = [Result_F_measure; F_measure];
    
    
    display('stop !!!') 
end
display('Precision  ... '); disp(mean(Result_Precision));
display('Recall  ...'); disp(mean(Result_Recall));
display('F-measure  ...'); disp((2*mean(Result_Precision)*mean(Result_Recall))/(mean(Result_Precision)+mean(Result_Recall)));
