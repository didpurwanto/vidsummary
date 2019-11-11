%% Draw
% Date : Nov/07/2017
% Input: keyframes.jpg (P6_Copy2Frames)
% Output: copy the frame to the folder (.jpg)
% Process: 
%% 
clc
clear
close all
tic;

% % figure
% % x = [256 512 1024];
% % y_ma = [62.7 62.9 62.4];
% % y_if = [62.0 62.3 61.8];
% % plot(x,y_ma,'b:p',x,y_if,'rv--');
% % set(gca,'XTick',[256 512 1024] );
% % grid on
% % axis tight
% % ylabel('F-measure')
% % xlabel('Dimension')
% % title('Comparative evaluation on YouTube dataset')
% % legend('Moving Average ','Independent Frame')

% % % % figure
% % x = [256 512 1024];
% % y_ma = [74.2 78.5 76.0];
% % y_if = [74.0 77.6 77.8];
% % plot(x,y_ma,'b:p',x,y_if,'rv--');
% % set(gca,'XTick',[256 512 1024] );
% % grid on
% % axis tight
% % ylabel('F-measure')
% % xlabel('Dimension')
% % title('Comparative evaluation on OVP dataset')
% % legend('Moving Average ','Independent Frame')


figure
setnum = 72;
x = [256 512 1024];
y = [74.0 74.2;77.6 78.5;75.9 76.0];
bar(y-setnum,'FaceColor','flat');
grid on
% axis tight
ylabel('F-measure')
xlabel('Dimension')
title('Comparative evaluation on OVP dataset')
legend('Independent Frame','Moving Average ')
set(gca, 'xticklabel', {'256','512','1024'}, 'YTickLabel',[0:1:10]+setnum);


figure
setnum_2 = 61;
x = [256 512 1024];
y = [62.0 62.7;62.3 63.1;61.8 62.4];
bar(y-setnum_2,'FaceColor','flat');
grid on
% axis tight
ylabel('F-measure')
xlabel('Dimension')
title('Comparative evaluation on YouTube dataset')
legend('Independent Frame','Moving Average ')
set(gca, 'xticklabel', {'256','512','1024'} , 'YTickLabel',[0:1:10]+setnum_2);
% % 
% % figure
% % xtl = {'4-2' '3-2' '3-2' '4-1' '3-1' '2-1'};
% % data = rand(6,3)+3;
% % figure(1)
% % hb = bar(data-3)
% % set(gca, 'XtickLabel', xtl)
% % set(hb(1),'FaceColor','c')
% % set(hb(2),'FaceColor','k')
% % set(hb(3),'FaceColor','r')
% % set(gca, 'YTick', [0:0.1:1], 'YTickLabel',[0:0.1:1]+3)

