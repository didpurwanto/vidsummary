%% ITQ
% Date : Aug/01/2017
% Input : cnn_fc7.mat
% Output : 
%% 
clc
clear
close all
%%  
tic;
%% --------------------- parameters --------------------- 
bit = 64;                         % Using  bits code length
itr_time = 100;

%% --------------------- Input video CNN feature ---------------------
load('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\AmericasNew_Frontier_seg3.mat'); % CNN 
name = 'AmericasNew_Frontier_seg3';

% load('C:\Users\T2-503-3\Desktop\testITQ\person01_boxing_d1_uncomp.mat');
% name = 'person01_boxing_d1_uncomp';
% load('D:\CNN_img\matlab\demo\feature_cnn_vsumm\fc7\v11.mat');
% name = 'v11'

% % % load('E:\CNN_img\matlab\demo\feature_hog_ovp\AmericasNew_Frontier_seg4.mat'); % hog
% % % name = 'AmericasNew_Frontier_seg4';
% % % feature_fc7 = temp';

load cifar_10yunchao.mat;

% % load Cifar10-Gist512.mat;
temp_odd = [];
temp_even = [];

% even
% --------------------- PCA ---------------------  
disp('PCA ...');
[x,y] = size(feature_fc7);
% [pca_A new_fc7]= fastPCA(double(feature_fc7),320); % function 
%feature_fc7
coe_tr = pca(feature_fc7');
choose_fc7 = coe_tr(:, 1:320);
new_fc7 = feature_fc7'*choose_fc7;

% --------------------- PCA ---------------------  
% temp_even = [temp_even feature_fc7(1:end,1:end)]; % for test
temp_even = new_fc7'; % for test

% odd
% temp_odd = [temp_odd feature_fc7(1:end,1:end)]; % for training
temp_odd = [temp_odd cifar10(1:end,1:end-1)']; % for training
% temp_odd = [temp_odd new_fc7']; % for training

% --------------------- Input video CNN feature ---------------------
[ndata, D] = size(feature_fc7');
Xtraining = double(temp_odd');
Xtest = double(temp_even');
num_training = size(Xtraining,1);

% generate training ans test split and the data matrix
XX = [Xtraining; Xtest];

% PCA ---------------------------------------------- original
% center the data, VERY IMPORTANT
% % sampleMean = mean(XX,1);                % error
sampleMean = mean(XX(1:num_training,:),1);  % correct
XX = (double(XX)-repmat(sampleMean,size(XX,1),1));
[pc, ~] = eigs(cov(XX(1:num_training,:)),bit);
XX = XX * pc;

% PCA --------------- original
% % % coe_tr = pca(XX(1:num_training,:));
% % % choose_tr = coe_tr(:, 1:bit);
% % % XX = XX(:,:)*choose_tr;


% ITQ
Y_Binary = []; % 記下原先的Binary Code
[Y, R] = ITQ(XX(1:num_training,:),itr_time);      % input 部分當作訓練資料 ITQ
XX = XX*R;
Y = zeros(size(XX));
Y(XX>=0) = 1;
Y_Binary = Y(60001:end,1:end);
Y = compactbit(Y>0);

% compute Hamming metric and compute recall precision
B1 = Y(1:size(Xtraining,1),:);       
B2 = Y(size(Xtraining,1)+1:end,:);          % test output Hamming Distance  
Dhamm = hammingDist(B2, B1);
[foo, Rank] = sort(Dhamm, 2,'ascend');      % sorted by hamming distance 
                                            % row(橫向)之間sort
                                            % foo sort後的結果   遞增
                                            % Rank sort前的index 遞增
% --------------------- Similarity Frames Computing ---------------------
B2_test= double(B2);
B1_train= double(B1);

sub_temp = [];
binary_code = [];
frame_index = [];

% 先記下第一組
frame_index = [frame_index; 1];
binary_code = [binary_code; B2_test(1,1:end)];

for i=1 : size(B2_test,1)
    sub_seek = [];
    for k=1 : size(binary_code,1)
        sub_temp = sum(abs(B2_test(i,1:end)-binary_code(k,1:end))); % 比較是否同一組
        sub_seek = [sub_seek; sub_temp];
        clear sub_temp
    end
    zero_count = length(find(sub_seek == 0)); % 計算0的個數
    
    if zero_count >= 1  % 如果有 0 ，代表binary code內已經存了
        display('already exist ');
        
    else                % 如果沒有 0
        frame_index = [frame_index; i];
        binary_code = [binary_code; B2_test(i,1:end)];
    end
    clear sub_seek
end
display('wait !!! ');

% --------------------- Similarity Frames Clustering ---------------------
binary_index = [];
for UU=1 : size(B2_test,1)
    
    for TT=1 : size(binary_code,1)
        same = isequal(B2_test(UU,:),binary_code(TT,:));
        
        if same == 1
            binary_index = [binary_index; TT];
        end
    end
end
% -------------------------- Hamming Distance ----------------------------
% compute the distance of hamming distance
% we need to decide the distance for selecting key-frame 
% Input: Y_Binary

HammDis_select = [];
HammDis_temp = [];
HammDis_select = [HammDis_select; 1];

HammDis_temp = Y_Binary;
for MM=1 : size(Y_Binary,1)-1
    sub_temp = sum(abs(HammDis_temp(MM,1:end) - HammDis_temp(MM+1,1:end)));
    
    if sub_temp > 1     % Hamming Distance 大於 X
        HammDis_select = [HammDis_select; MM+1];
    end
         
    clear sub_temp
end
% % save(['D:\CNN_img\matlab\demo\ITQ_HamDis\SumMe\Bit_64\IT_100\1/' name '.mat'], 'HammDis_select');


% -------------------------- Hamming Distance ----------------------------
%% Save the file
% % save(['E:\CNN_img\matlab\demo\ITQ_HamDis\OVP/' name '.mat'], 'frame_index');                                  
display('Saved the ITQ Frame Index ... ');
% % sum(abs(Y_Binary(60003,1:end)-Y_Binary(60004,1:end)));
% --------------------- Similarity Frames Computing ---------------------   
toc;