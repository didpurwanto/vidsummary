clc
clear
close all

disp('ITQ modelling');

bit_length = 64;
iter_time = 100;

path = '..\data\cnn_summe';
source = dir([path,'\*.mat']);
n = length(source);

for  i=1:n
    load(data);
end
