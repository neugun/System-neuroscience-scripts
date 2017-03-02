%%每次使用opsignal把这些文件转移到另一个csv文件中，
%每次一些文件之前的设定参数必须要清楚，尤其是psth_wave2的设定参数
%trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score
%%%%%%%%%%%%%%%drawErrorline需要提前预设值
open zzgprotocol;
open lightstimulate;
open manual_marker100hz;
open addcsv;
open  OpSignal;
open plotsummary;
open drawErrorLine_1;



打开原始文件，每个文件需要一个文件夹。
clc;clear;
%%open manual marker;interger;                                                      
为了保证时间的准确性和信号有效性，需要匹配钙信号和视频一起看，得到一些显著的结果即可
所有的时间差值需要在原始的csv中通过lightstimulate得到。之后利用分析得到的l，将其合并成第二格。最后相减得到timelapse,输入不为0的数。
利用python把所有的txt转换为多个文件的csv,最后利用小程序把这些文件的csv,全部合并到marker file中。
一定要注意其中的文件空格要删除。

addmarkertime;                                                                        %%%%%%%%%%%%%%输入文件夹
把markerfile.csv复制到原文件夹中
手动打开lightingcamp,确认无误。

manual_marker100hz;                                                                   %timelapse              ;interger
把output20170112-3rd left 1.csv 复制到原文件夹中
clc;clear;
先用opsignal简单查看数据

addmarkertime;
更换addmarkertime文件夹名字,再运行一遍
manual_marker100hz;
更换name1,name3.


addcsv;
%%%%%%%%%%%%%%%%%%%%%%%让六只或者N只小鼠的output文件合并。具体步骤为，生成各自的marker file.xlsx,都是四列，然后再使用manual marker100hz得到每个文件的output。在最后一步后能够自动得到output文件。%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 OpSignal;
请勿删除psth_DATAunit，开始前将psth_DATAunit归零。
设定cue=1;假如cue不为1时，则comment。
%%%%%%五个cue:abcd四列表示b  f  fs  ms m.总共七列，最后一列为数值。
%input 
%output.csv ; cue ; 
%load output;bin=1;samplerate=1；heatmap;deltaF/F; Clims=[];average;
%%%%%%%%%%%%%%                       time=- 2s；4 s
%csvwrite('psth_DATAunit.csv',psth1_mean);  
%%%%%%%%%%%%在第一个cue值为1时，为1
%%%%%%%%%%%%在第一个cue值不为1时，为9

%%%%%%%%%%%%output 
%%%%%%%%%%%psth_size.csv;psth_idx.csv;psth_DATAunit.csv;
%%%%%%%%%%%deltaF-F.csv;z_score1.csv;
%%%%%%%%%%%%输出了两个fig ,一个是排序过的结果，一个是把明显的结果得到。
一定要按顺序，将cue都选择后，得到结果。但是切换过程中需要变换tif的名称，再将文件复制一次，重现开始另一个cue。最终得到一个汇总的psth_DATAunit
切换heatmap和deltaf/f.



plotsummary;
%%%%%%%%%%%%%%%%%%%%%先看一下psth_DATAunit有几列
%%%%%%%%%%%%%%%%%%%%% input  basal_time=2;interval=0.01;odor_time=4;
%%%%%%%%%%%%%%%%%%%%%%%需要画的线条数取决于        i=[1,3,4,5]
%total time =12s
%%%%%%%%%%%%%%%drawErrorline需要提前预设值
%plot([-2,4],[1,1],'--r','LineWidth',2);
%plot([0,0],[-2,10],'--r','LineWidth',2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%z_score=0;





 
%还需要选择三个4s的deltaF/F值做统计。得到点状的图。
%%%%%%%%%%%%%%%%%%%%%%%%%%最后的m数值肯定有一定问题，因为每个得到的值都差异很大，需要进行初步的筛选，利用最早版本的drawall，另外aggression的次数太大，导致数值比正常要小很多。也需要初步的剪掉一些值。