%%ÿ��ʹ��opsignal����Щ�ļ�ת�Ƶ���һ��csv�ļ��У�
%ÿ��һЩ�ļ�֮ǰ���趨��������Ҫ�����������psth_wave2���趨����
%trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score
%%%%%%%%%%%%%%%drawErrorline��Ҫ��ǰԤ��ֵ
open zzgprotocol;
open lightstimulate;
open manual_marker100hz;
open addcsv;
open  OpSignal;
open plotsummary;
open drawErrorLine_1;



��ԭʼ�ļ���ÿ���ļ���Ҫһ���ļ��С�
clc;clear;
%%open manual marker;interger;                                                      
Ϊ�˱�֤ʱ���׼ȷ�Ժ��ź���Ч�ԣ���Ҫƥ����źź���Ƶһ�𿴣��õ�һЩ�����Ľ������
���е�ʱ���ֵ��Ҫ��ԭʼ��csv��ͨ��lightstimulate�õ���֮�����÷����õ���l������ϲ��ɵڶ����������õ�timelapse,���벻Ϊ0������
����python�����е�txtת��Ϊ����ļ���csv,�������С�������Щ�ļ���csv,ȫ���ϲ���marker file�С�
һ��Ҫע�����е��ļ��ո�Ҫɾ����

addmarkertime;                                                                        %%%%%%%%%%%%%%�����ļ���
��markerfile.csv���Ƶ�ԭ�ļ�����
�ֶ���lightingcamp,ȷ������

manual_marker100hz;                                                                   %timelapse              ;interger
��output20170112-3rd left 1.csv ���Ƶ�ԭ�ļ�����
clc;clear;
����opsignal�򵥲鿴����

addmarkertime;
����addmarkertime�ļ�������,������һ��
manual_marker100hz;
����name1,name3.


addcsv;
%%%%%%%%%%%%%%%%%%%%%%%����ֻ����NֻС���output�ļ��ϲ������岽��Ϊ�����ɸ��Ե�marker file.xlsx,�������У�Ȼ����ʹ��manual marker100hz�õ�ÿ���ļ���output�������һ�����ܹ��Զ��õ�output�ļ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 OpSignal;
����ɾ��psth_DATAunit����ʼǰ��psth_DATAunit���㡣
�趨cue=1;����cue��Ϊ1ʱ����comment��
%%%%%%���cue:abcd���б�ʾb  f  fs  ms m.�ܹ����У����һ��Ϊ��ֵ��
%input 
%output.csv ; cue ; 
%load output;bin=1;samplerate=1��heatmap;deltaF/F; Clims=[];average;
%%%%%%%%%%%%%%                       time=- 2s��4 s
%csvwrite('psth_DATAunit.csv',psth1_mean);  
%%%%%%%%%%%%�ڵ�һ��cueֵΪ1ʱ��Ϊ1
%%%%%%%%%%%%�ڵ�һ��cueֵ��Ϊ1ʱ��Ϊ9

%%%%%%%%%%%%output 
%%%%%%%%%%%psth_size.csv;psth_idx.csv;psth_DATAunit.csv;
%%%%%%%%%%%deltaF-F.csv;z_score1.csv;
%%%%%%%%%%%%���������fig ,һ����������Ľ����һ���ǰ����ԵĽ���õ���
һ��Ҫ��˳�򣬽�cue��ѡ��󣬵õ�����������л���������Ҫ�任tif�����ƣ��ٽ��ļ�����һ�Σ����ֿ�ʼ��һ��cue�����յõ�һ�����ܵ�psth_DATAunit
�л�heatmap��deltaf/f.



plotsummary;
%%%%%%%%%%%%%%%%%%%%%�ȿ�һ��psth_DATAunit�м���
%%%%%%%%%%%%%%%%%%%%% input  basal_time=2;interval=0.01;odor_time=4;
%%%%%%%%%%%%%%%%%%%%%%%��Ҫ����������ȡ����        i=[1,3,4,5]
%total time =12s
%%%%%%%%%%%%%%%drawErrorline��Ҫ��ǰԤ��ֵ
%plot([-2,4],[1,1],'--r','LineWidth',2);
%plot([0,0],[-2,10],'--r','LineWidth',2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%z_score=0;





 
%����Ҫѡ������4s��deltaF/Fֵ��ͳ�ơ��õ���״��ͼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%����m��ֵ�϶���һ�����⣬��Ϊÿ���õ���ֵ������ܴ���Ҫ���г�����ɸѡ����������汾��drawall������aggression�Ĵ���̫�󣬵�����ֵ������ҪС�ܶࡣҲ��Ҫ�����ļ���һЩֵ��