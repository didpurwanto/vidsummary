clc
clear
close all

% select the process, uncomment the unnecessary process

%% old
% run('P1_ITQ_Model.m')
% run('P1_ITQ_train.m')
% run('P2_Darwin_HamDist.m')
% run('P4_SNIP_ITQ.m')
% run('P6_Copy2Frames.m')
% run('P7_OVP_Evaluate.m')
% run('P7_VSUMM_Evaluate.m')

%% new
run did_extract_fc7
run did_modeling_itq
