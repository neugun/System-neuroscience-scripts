%%%%%%%%%%%%%heatmap
%%%%%%%%%%%%%psth
clc;
% read ori_csv file  
%%%%%%%%%%%%%basal odortime需要自己设定
%%%%%%%%%%%%%%%%%%%%%%需要画的线条数取决于                                                                    i=[1,3,4,5]
%%%%%%%%%%%%%                                                                                                 z_score=0;
%%%%%%%%%%%%%                                                                                     需要用到函数drawerrorline
z_score=0;
folder_name = 'M:\OpSignal-MATLAB-20160712\samplerate=100\';  %%
input_csv = 'psth_DATAthy1gadvglut2.csv'; %%                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%% read psth_DATAunit.csv
color=['r','b','g','magenta','k'];
str=['aggression', 'loomingfear','female sniff','male sniff'];  %%%%%%%%%%%%%%  ['aggression', 'loomingfear','female sniff','male sniff','motion','motion'];
line=[1,2,3];%% line=[1,2,3,4,5];
str1=input_csv;
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%最主要要把psth1_mean,psth1_sem得到，然后把得到的值利用后面的drawErrorLine画出。能否自己定义一个函数 psthdata
%the_title = get(handles.edit_file,'String');  %标题

basal_time=2;
interval=0.01;
odor_time=4;
times = -basal_time:interval:odor_time-0.01;  %时间是从-2到9.99？？？，但是间隔是0.01
psth1_mean=psth_DATAunit(1:2:end,:);
psth1_sem=psth_DATAunit(2:2:end,:);                                 
%size(psth1,2)表示返回的列数 %csvwrite('psth_unit.csv',size(psth1,1)); 
figure; subplot(1,1,1);
   %%%%%%%%%%%%%%%   color=['r','b','g','magenta','k'];  
   %%%%%%%%%%% line=[1,2,3,4,5];
N=length(line);
   for  i=line                                                                         %%%%%%%%%%%%%%%%%%%%%%需要画的线条数取决于        i=[1,2,3,4,5]
  drawErrorLine_1(times,psth1_mean(i,:),psth1_sem(i,:),color(i),1);   %误差线作图方法，输入时间，平均值，SEM，red标注,                 
    %%%%%%%%这个才是画图的最主要工具   %
   end
legend('aggression', 'loomingfear','female sniff','male sniff','Location','NorthEast') ;% ['aggression', 'loomingfear','female sniff','male sniff','motion','motion'];

plot([-2,4],[0.0,0.0],'--r','LineWidth',2);
plot([0,0],[-0.02,0.05],'--r','LineWidth',2);
hold on;



%title(the_title); %不需要这个名字，换成                                             
xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');  %更换标题  
       folder_name = folder_name;  %%
input_csv = 'z_score1.csv'; %%   
psth1=csvread([folder_name, input_csv]);
       else
         ylabel('deltaF/F'); %更换标题
         folder_name = folder_name;  %%
input_csv = 'deltaF-F.csv'; %%   
psth1=csvread([folder_name, input_csv]);    
       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       filename = [foldername,'\',newname,'.txt'];
fid=fopen(filename,'wt');   

       name111='.tif';
name111=[str1,name111]; 
saveas(gcf, name111);     