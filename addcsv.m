
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
filename1='I:\OpSignal-MATLAB-20160712\samplerate=100\';
name1='170112thy1_psi.csv';
name2='output20170223-thy1.csv';
% name3='output20170223-thy1_1#_right1.csv';
% name4='output20170223-thy1_1#_right2.csv';
% name5='output20170223-thy1_2#_left1.csv';
% name6='output20170223-thy1_2#_right1.csv';


name7='outputall-thy1.csv';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  输出一个包括多个output文件的结果。首先把文件output.csv通过该程序得到，再利用此循环。
folder_name = filename1;  %%
input_csv = name1; %%   
ori_1=csvread([folder_name, input_csv]);
folder_name = filename1;  %%
input_csv = name2; %%   
ori_2=csvread([folder_name, input_csv]);
% folder_name = filename1;  %%
 % input_csv = name3; %%   
% ori_3=csvread([folder_name, input_csv]);
% folder_name = filename1;  %%
% input_csv = name4; %%   
% ori_4=csvread([folder_name, input_csv]);
% folder_name = filename1;  %%
% input_csv = name5; %%   
% ori_5=csvread([folder_name, input_csv]);
% folder_name = filename1;  %%
% input_csv = name6; %%   
% ori_6=csvread([folder_name, input_csv]);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


ori_data=[ori_1;ori_2];
%ori_1;ori_2;ori_3;ori_4;ori_5;ori_6];



csvwrite(name7,ori_data); % 输出打标后文件
clc;
clear;
