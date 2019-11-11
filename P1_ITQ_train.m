%% ITQ_other dataset 
% Date :    Aug/01/2017
% Input :   cnn_fc7.mat
% Output :  ITQ_selected_hamming_dstance.mat
% Train data from  P1_ITQ_Model.m
%% 
clc
clear
close all
%%  
tic;
%% --------------------- parameters setting --------------------- 
bit = 64;                         % Using  bits code length
itr_time = 100;

%% --------------------- Input video CNN feature ---------------------
% % srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_vsumm\test_3\*.mat'); % VSUMM
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7_ovp_test_3\*.mat'); % OVP
totalVideo = length(srcFiles);

for i=1 :totalVideo
    % --------------------- Loading the Darwin Score ---------------------
    filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7_ovp_test_3\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4);
    display('Load data ... ');load(filename);
    

%% --------------------- PCA Train---------------------(P1_ITQ_Model.m)
% % % load ovp_40.mat;
% % % temp_odd = [];
% % % %%%%%% train pca %%%%%%
% % % ovp10 = ovp_all;
% % % coe_ovp10 = pca(ovp10);
% % % choose_ovp10 = coe_ovp10(:, 1:1024);
% % % new_data = ovp10*choose_ovp10;

%% --------------------- Train Model ---------------------(P1_ITQ_Model.m)
load OVP_1024_pre5.mat;                    % OVP dataset form random folder
% % load vsumm_1024_pre5.mat;                    % VSUMM dataset

% % % load cifar_10yunchao.mat;            % Original Paper using

% --------------------- Test data PCA ---------------------
%%%%%% test pca %%%%%%
% % [pca_A new_fc7]= fastPCA(double(feature_fc7),320);
% % [COEFF,score,laten] = princomp(feature_fc7);
%%%%%% test pca %%%%%%
disp('PCA ...');
dim_set = 1024;
[x,y] = size(feature_fc7);
coe_tr = pca(feature_fc7');
choose_fc7 = coe_tr(:, 1:dim_set);
new_fc7 = feature_fc7'*choose_fc7;

% --------------------- PCA --------------------- 
temp_even = [];
temp_even = new_fc7; % for test

% odd
% % % temp_odd = [temp_odd new_data(1:end,1:end)]; % for training 


%% --------------------- random ---------------------(P1_ITQ_Model.m)
% % tic;
% % disp('Random ...');
% % [train_l train_dim] = size(new_data);
% % rand_index = randsample(1:train_l,train_l)';
% % for i=1 : size(rand_index,1)
% %     rr = rand_index(i,:);
% %     temp_odd = [temp_odd; new_data(rr,:)];
% %     
% % end
% % disp('Random done ...');
% % toc;
%% --------------------- Input video CNN feature ---------------------
[ndata, D] = size(feature_fc7');
Xtraining = double(temp_odd);
Xtest = double(temp_even);
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
% % Y_Binary = []; % 記下原先的Binary Code
[Y, R] = ITQ(XX(1:num_training,:),itr_time);      % input 部分當作訓練資料 ITQ
XX = XX*R;
Y = zeros(size(XX));
Y(XX>=0) = 1;
% % % Y_Binary = Y(train_l+1:end,1:end);
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
% 計算排序有幾組binary code
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
        
    else                % 如果沒有 0 ，存起那組
        frame_index = [frame_index; i];
        binary_code = [binary_code; B2_test(i,1:end)];
    end
    clear sub_seek
end
display('wait !!! ');

% --------------------- Similarity Frames Clustering ---------------------
% 求出所有的B2_test的index
% binary_index 為所有B2_test的index
% index 從binary_code 當代表

binary_index = [];
for UU=1 : size(B2_test,1)
    
    for TT=1 : size(binary_code,1)
        same = isequal(B2_test(UU,:),binary_code(TT,:));    % 是否相同
        
        if same == 1
            binary_index = [binary_index; TT];
        end
    end
end
% -------------------------- Hamming Distance ----------------------------
% compute the distance of hamming distance
% we need to decide the distance for selecting key-frame 
% Input: B2_test

HammDis_select = [];
HammDis_temp = [];
HammDis_select = [HammDis_select; 1];

HammDis_temp = B2_test;
for MM=1 : size(B2_test,1)-1
    
    sub_temp = sum(abs(HammDis_temp(MM,1:end) - HammDis_temp(MM+1,1:end)));
    
    if sub_temp > 1     % Hamming Distance 大於 X ，目前設定 X = 1
        HammDis_select = [HammDis_select; MM+1];
    end
         
    clear sub_temp
end
% -------------------------- Hamming Distance end----------------------------

%% Save the file                             
display('Saved the ITQ Frame Index ... ');

% OVP dataset
save(['D:\CNN_img\matlab\demo\ITQ_HamDis\OVP\Bit_64\IT_100\pre_5\test_3\1_1024/' name '.mat'], 'HammDis_select');

% VSUMM dataset
% % save(['D:\CNN_img\matlab\demo\ITQ_HamDis\vsumm\Bit_64\IT_100\pre_5\test_3\1_1024/' name '.mat'], 'HammDis_select');

end
toc;

% % sum(abs(Y_Binary(60003,1:end)-Y_Binary(60004,1:end)));
