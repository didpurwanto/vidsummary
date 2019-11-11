%% Main
% Date : Dec/19/2017
% Input: 
% Output: 
clc
clear 
close all
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
disp(['Select the mode:(Input 1~7)']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
disp(['1:I33TQ Model training']);
disp(['2:ITQ Model testing']);
disp(['3:Darwin Hammimg Distance']);
disp(['4:SNIP']);
disp(['5:Copy the results frames']);
disp(['6:Evaluate - OVP']);
disp(['7:Evaluate - VSUMM']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
% Model_num = input('Select mode?'); 
Model_num = 1;

if Model_num == 1
    tic;
    run P1_ITQ_Model.m
    toc;
end

if Model_num == 2
    tic;
    run P1_ITQ_train.m
    toc;
end

if Model_num == 3
    tic;
    run P2_Darwin_HamDist.m
    toc;
end

if Model_num == 4
    tic;
    run P4_SNIP_ITQ.m
    toc;
end

if Model_num == 5
    tic;
    run P6_Copy2Frames.m
    toc;
end

if Model_num == 6
    tic;
    run P7_OVP_Evaluate.m
    toc;
end

if Model_num == 7
    tic;
    run P7_VSUMM_Evaluate.m
    toc;
end
