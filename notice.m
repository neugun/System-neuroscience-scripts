%%每次使用opsignal把这些文件转移到另一个csv文件中，
%每次一些文件之前的设定参数必须要清楚，尤其是psth_wave2的设定参数
%trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score
open notice;
%以下命令可复制
clc;clear;
%open opsignal2, first 6 rows no data;other 10 rows spike ; the last 3%%rows=emg,etc.  paste,pastepastepaste
%open manual marker;interger;                                                          pastepastepaste
manual_marker;%start time;duration; row numbers;
clc;clear;
 OpSignal;
%load output;bin=1;samplerate=1；heatmap;deltaF/F; Clims=[];average;
%only 2 kinds of data,average
%%and emg now!!!!!!!!!!!!!
%psth is ok,we can average every neurons after!
%csvwrite('psth_DATAunit.csv',psth1_mean);   
%psth_DATAunit每次换完一个csv文件后,需要将相同cue的文件手动合并，最终得到一个unit数目很多的文件。
plotsummary;
%好像图形没有smooth过？？？
%目前还没有在一个图中画很多线段。
%total time =12s
