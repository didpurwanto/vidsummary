%% CNN Extracted Featrue
% Date : Apr/10/2017
% Input:  frame.jpg (P0_Video2Frame)
% Output: feature_fc7.mat 

clc
clear 
close all
tic;
%% 
caffe.reset_all();
caffe.set_mode_cpu();
% % caffe.set_mode_gpu();
% % gpu_id = 0;  % we will use the first gpu in this demo
% % caffe.set_device(gpu_id);
load ('D:\CNN_img\matlab\+caffe\imagenet\ilsvrc_2012_mean.mat'); % load mean
%% --------------
% % % % caffe.set_mode_gpu();
% % caffe.set_mode_cpu();
% % gpu_id = 0;  % we will use the first gpu in this demo
% % % % caffe.set_device(gpu_id);
% % load ('D:\CNN_img\matlab\+caffe\imagenet\ilsvrc_2012_mean.mat'); % load mean

model_dir = '../../models/bvlc_reference_caffenet/';
net_model = [model_dir 'deploy.prototxt'];
net_weights = [model_dir 'bvlc_reference_caffenet.caffemodel'];
phase = 'test'; % run with phase test (so that dropout isn't applied)
if ~exist(net_weights, 'file')
  error('Please download CaffeNet from Model Zoo before you run this demo');
end

% Initialize a network
net = caffe.Net(net_model, net_weights, phase);

% create net and load weights
% % net = caffe.Net('deploy.prototxt', 'bvlc_reference_caffenet.caffemodel', 'test');
net.blobs('data').reshape([227 227 3 1]);
choose_to_delete_zero=1; % Set this to 1 to delete zero(padding zero) in the proposals
                         % If this is 0, it means that padding zero will remain in the proposals 

%% ---------------------------- Input your video frames ---------------------------- 
srcFiles = dir('D:\Dataset\SumMe\frame\playing_ball\*.jpg'); % 計算有多少張圖片
totalImage = length(srcFiles);
feature_fc7 = [];
for i=1 : totalImage
    filename = strcat('D:\Dataset\SumMe\frame\playing_ball\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4);
% %     jpgFilename = strcat(name, '.jpg');
    jpgFilename = strcat(name, '.jpg');
    
    % load image and forward (do this on each image)
%     im_data = caffe.io.load_image('00001.jpg');
    im_data = caffe.io.load_image(jpgFilename);
    im_data = imresize(im_data, [256 256]) - mean_data; % resize to 256 x 256 and subtract mean
    im_data = im_data(15:241, 15:241, :);       % take 227 x 227 center crop
    res = net.forward({im_data});               % run forward
    % feat = net.blobs('conv5').get_data();%conv5
    output_FC7 = net.blobs('fc7').get_data();   % FC7是我要的
    feature_fc7 = [feature_fc7 output_FC7];
    
    prog0 = sprintf('Extracted CNN Feature ... ... ... (%d/%d) Done     !!!!', i, totalImage);
    disp(prog0);
    
    clear im_data;
    clear output_FC7
end
toc;
save('D:\CNN_img\matlab\demo\feature_cnn_SumMe\fc7\playing_ball.mat','feature_fc7')
display('Saved CNN Feature Done !!!! ');

