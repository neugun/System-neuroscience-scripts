clc;
clear;
close all;
                                                                                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���һ���������output�ļ��Ľ�������Ȱ��ļ�output.csvͨ���ó���õ��������ô�ѭ����
folder_name = 'D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=100\';  %%
input_csv = '20170112-5rd right 1.csv'; %%   
ori_data=csvread([folder_name, input_csv]);
cal_data=ori_data(:,1);
a = find(cal_data == 1);
a=a/100;
csvwrite('lightingcamp.csv',a); % ���detalF/Fֵ