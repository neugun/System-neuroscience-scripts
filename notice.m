%%ÿ��ʹ��opsignal����Щ�ļ�ת�Ƶ���һ��csv�ļ��У�
%ÿ��һЩ�ļ�֮ǰ���趨��������Ҫ�����������psth_wave2���趨����
%trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score
open notice;
%��������ɸ���
clc;clear;
%open opsignal2, first 6 rows no data;other 10 rows spike ; the last 3%%rows=emg,etc.  paste,pastepastepaste
%open manual marker;interger;                                                          pastepastepaste
manual_marker;%start time;duration; row numbers;
clc;clear;
 OpSignal;
%load output;bin=1;samplerate=1��heatmap;deltaF/F; Clims=[];average;
%only 2 kinds of data,average
%%and emg now!!!!!!!!!!!!!
%psth is ok,we can average every neurons after!
%csvwrite('psth_DATAunit.csv',psth1_mean);   
%psth_DATAunitÿ�λ���һ��csv�ļ���,��Ҫ����ͬcue���ļ��ֶ��ϲ������յõ�һ��unit��Ŀ�ܶ���ļ���
plotsummary;
%����ͼ��û��smooth��������
%Ŀǰ��û����һ��ͼ�л��ܶ��߶Ρ�
%total time =12s
