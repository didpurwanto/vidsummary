%%
clc
clear 
close all
%% SVM training
% % % load('D:\CNN_img\matlab\demo\feature_cnn_OVP\OVP_cnn_14.mat');
% % % load('D:\CNN_img\matlab\demo\feature_cnn_OVP\label\OVP_label.mat');
% % % trainingData = sparse(double(cnn_fc7));
% % % trainingLabel = label';
% % % % liblinear_options = '-s 0 -t 0 -c 1';
% % % liblinear_options = '-c 1 -s 2'; % -c 1 % -s 11 -w1 1 -w2 5
% % % model = train(trainingLabel, trainingData, liblinear_options);
% % % [predict_label, accuracy, decision_values_train] = predict(trainingLabel, trainingData, model);
% % % % display(decision_values_train);
% % % 
% % % save(['model/' 'Model_' 'OVP_14.mat'],'model');
% % % display('Saving the model ... ');

%% SVM testing
clc
clear 
close all
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\test\*.mat');
totalVideo = length(srcFiles);
count_key = [];
for i = 4 :4 
    tic;
    filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\test\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4); 
    load(filename);
    
    testingData = sparse(double(feature_fc7')); % fv_s41
    [A_row A_col] = size(testingData);
    label(1:A_row) = 0;
    testingLabel= label';
    
    prog0 = sprintf('Preprocessing ... ... ... ... ... ... (%d/%d)', i, 4);
    disp(prog0);
    
    load(['D:\CNN_img\matlab\demo\model\Model_OVP_14.mat']);                      % liblinear svm model
	[predicted_label, accuracy, decision_values] = predict(testingLabel, testingData, model);
    count_key = [count_key; decision_values];
    
    [max_num, max_loc] = sort(count_key, 'descend');
    top_max = sort(max_loc(1:100), 'ascend');
    


end