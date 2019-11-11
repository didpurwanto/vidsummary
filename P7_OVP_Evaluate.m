%% OVP dataset Evaluate Protocol
% Date : Nov/07/2017
% Input: keyframes.jpg (P6_Copy2Frames)
% Output: copy the frame to the folder (.jpg)
% Process: based on evaluate protocol
%% 
clc
clear
close all
tic;

% srcFiles_index = dir('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\pre_5\test_4\1_1024\*.mat');
srcFiles_index = dir('./ITQ_HamDis/OVP/Bit_64/IT_100/pre_5/test_5/1_512/*.mat');
totalVideo_index = length(srcFiles_index);

Result_Precision = [];
Result_Recall = [];
Result_F_measure = [];

for i=1 : totalVideo_index
    % --------------------- Loading the frame index number ---------------------
%     filename_index = strcat('D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\pre_5\test_4\1_1024\',srcFiles_index(i).name);
    filename_index = strcat('./ITQ_HamDis/OVP/Bit_64/IT_100/pre_5/test_5/1_512/',srcFiles_index(i).name);
    name_index = srcFiles_index(i).name(1: end-4);
	display('Load index Name ... ');
    
    %--------------- input gt image ---------------%
    srcFiles_gt = dir(['D:\Dataset\OVP_Train\OVP_GT\test_5\',name_index,'\*.jpg']);   % input index那部影片的原image
    total_image_gt = length(srcFiles_gt);
    
    %--------------- input resulte image ---------------%
    srcFiles_re = dir(['D:\Results_work\OVP_ITQ\SNIP\test_5\pre_5\ma\1_512\',name_index,'\*.jpg']);   % input index那部影片的原image
    total_image_re = length(srcFiles_re);
    
    %--------------- recall ---------------%
    tic;
    Recall_temp = 0;
    for k=1: total_image_gt
        
        filename_gt = strcat('D:\Dataset\OVP_Train\OVP_GT\test_5\',name_index,'\',srcFiles_gt(k).name);
        name_gt = srcFiles_gt(k).name(1: end-4);
        Img_gt = imread(filename_gt);
% %         figure
% %         imshow(Img_gt);

        for p=1: total_image_re
            filename_re = strcat('D:\Results_work\OVP_ITQ\SNIP\test_5\pre_5\ma\1_512\',name_index,'\',srcFiles_re(p).name);
            name_re = srcFiles_re(p).name(1: end-4);
            Img_re = imread(filename_re);
% %             figure
% %             imshow(Img_re);

            [ssimval,ssimmap] = ssim(Img_re, Img_gt); % ssim(a, ref);

            if ssimval > 0.4
                Recall_temp = Recall_temp+1;
                break
            end            
        end
    end
    Recall = (Recall_temp/total_image_gt)*100;
    toc;
    
    %--------------- precesion ---------------%
    tic;
    Precision_temp = 0;
    for p=1: total_image_re
        
        filename_re = strcat('D:\Results_work\OVP_ITQ\SNIP\test_5\pre_5\ma\1_512\',name_index,'\',srcFiles_re(p).name);
        name_re = srcFiles_re(p).name(1: end-4);
        Img_re = imread(filename_re);
        
        for k=1: total_image_gt
        
            filename_gt = strcat('D:\Dataset\OVP_Train\OVP_GT\test_5\',name_index,'\',srcFiles_gt(k).name);
            name_gt = srcFiles_gt(k).name(1: end-4);
            Img_gt = imread(filename_gt);
            
            [ssimval,ssimmap] = ssim(Img_gt, Img_re); % ssim(a, ref);
            
            if ssimval > 0.4
                Precision_temp = Precision_temp+1;
                break
            end 
        end
    end
    Precision = (Precision_temp/total_image_re)*100;
    toc;
    
    %--------------- f-measure ---------------%
    F_measure = (2*Precision*Recall)/(Precision+Recall);
    
    %--------------- Results ---------------%
    Result_Precision = [Result_Precision; Precision];
    Result_Recall = [Result_Recall; Recall];
    Result_F_measure = [Result_F_measure; F_measure];
    
    display('Load index Name ... ');
end
%--------------- input gt image ---------------%
display('Precision  ... '); disp(mean(Result_Precision));
display('Recall  ...'); disp(mean(Result_Recall));
display('F-measure  ...'); disp((2*mean(Result_Precision)*mean(Result_Recall))/(mean(Result_Precision)+mean(Result_Recall)));


% % img1=imread('D:\Dataset\OVP_Train\OVP_GT\ANew_Horizon_seg5\01621.jpg');
% % img2=imread('D:\Results_work\OVP_ITQ\SNIP\ma_Max_512_40\ANew_Horizon_seg5\01568.jpg');
% % [ssimval,ssimmap] = ssim(img1, img2); % ssim(a, ref);