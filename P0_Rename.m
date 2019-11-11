%% 
clc
clear
close all
tic;
%% Input file
srcFiles = dir('C:\Users\wenchi\Desktop\test123\*.jpg');
totalVideo = length(srcFiles);

for i=1 : totalVideo
    
    filename = strcat('C:\Users\wenchi\Desktop\test123\',srcFiles(i).name);
    name = srcFiles(i).name(1: end-4);
    display('Load Index ... ');
    img_Filename = strcat(name,'.jpg');
% %     load(filename);
        
    Max_image_length = length(num2str(floor(totalVideo))); % 求出數值的位數
    Now_image_length = length(num2str(floor(str2num(name))));
    bit_length = Max_image_length - Now_image_length;
   
   
    movefile(files(id).name, sprintf('%03d.jpg', num));
    
    
    display('123');
end

% Get all PDF files in the current folder
files = dir('C:\Users\wenchi\Desktop\test123\*.jpg');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(id).name);
      % Convert to number
      num = str2double(f);
      if ~isnan(num)
          % If numeric, rename
          movefile(files(id).name, sprintf('%03d.jpg', num));
      end
end