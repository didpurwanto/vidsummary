%% Temporal and Spatial Feature FV Encoding
% Date : Mar/25/2017
% Input : feature_cnn.mat 
% Output : OPV_14_all.mat
% Process : 將所有的feature combine在一起
%% 
clc
clear
close all
tic;
%% Input file
srcFiles = dir('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\train\*.mat'); % OVP_14videos
totalVideo = length(srcFiles);
cnn_fc7 = []; 
for i=1 : totalVideo
    temp_fc7 = []; 
    filename = strcat('D:\CNN_img\matlab\demo\feature_cnn_OVP\fc7\train\',srcFiles(i).name); 
    name = srcFiles(i).name(1: end-4);
    
    % load the feature in the temp
    prog = sprintf('     Loading %s (%d/%d)',srcFiles(i).name, i, totalVideo);
	disp(prog);
    load(filename);
    temp_fc7 = feature_fc7'; 
 
    
    % Concanate   
	cnn_fc7 = vertcat(cnn_fc7, temp_fc7);

end
%% Save Testing Fisher Vector
save -v7.3 'D:\CNN_img\matlab\demo\feature_cnn_OVP\OVP_cnn_14.mat' 'cnn_fc7' 
display('---------------///--------------- ');
% concanate all and save it
% % all_feature = [];
% % all_feature = [fv_s41;];
% % save('D:\TDD\TDD\feature_OVP\combine\OVP_14_All.mat','all_feature');
display('---------------///--------------- ');
display('    Saved the feature done');
toc;
%% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
display('---------------///--------------- ');
