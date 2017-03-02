clc;
clear;
close all;
                                                                                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  输出一个包括多个output文件的结果。首先把文件output.csv通过该程序得到，再利用此循环。
folder_name = 'D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=100\';  %%
input_csv = '20170112-5rd right 1.csv'; %%   
ori_data=csvread([folder_name, input_csv]);
cal_data=ori_data(:,1);
a = find(cal_data == 1);
a=a/100;
csvwrite('lightingcamp.csv',a); % 输出detalF/F值