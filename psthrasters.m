%%%%%%%%%%%%%heatmap
%%%%%%%%%%%%%psth
clc;
% read ori_csv file  
%%%%%%%%%%%%%basal odortime��Ҫ�Լ��趨
%%%%%%%%%%%%%%%%%%%%%%��Ҫ����������ȡ����                                                                    i=[1,3,4,5]
%%%%%%%%%%%%%                                                                                                 z_score=0;
%%%%%%%%%%%%%                                                                                     ��Ҫ�õ�����drawerrorline
z_score=0;
folder_name = 'M:\OpSignal-MATLAB-20160712\samplerate=100\';  %%
input_csv = 'psth_DATAthy1gadvglut2.csv'; %%                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%% read psth_DATAunit.csv
color=['r','b','g','magenta','k'];
str=['aggression', 'loomingfear','female sniff','male sniff'];  %%%%%%%%%%%%%%  ['aggression', 'loomingfear','female sniff','male sniff','motion','motion'];
line=[1,2,3];%% line=[1,2,3,4,5];
str1=input_csv;
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%����ҪҪ��psth1_mean,psth1_sem�õ���Ȼ��ѵõ���ֵ���ú����drawErrorLine�������ܷ��Լ�����һ������ psthdata
%the_title = get(handles.edit_file,'String');  %����

basal_time=2;
interval=0.01;
odor_time=4;
times = -basal_time:interval:odor_time-0.01;  %ʱ���Ǵ�-2��9.99�����������Ǽ����0.01
psth1_mean=psth_DATAunit(1:2:end,:);
psth1_sem=psth_DATAunit(2:2:end,:);                                 
%size(psth1,2)��ʾ���ص����� %csvwrite('psth_unit.csv',size(psth1,1)); 
figure; subplot(1,1,1);
   %%%%%%%%%%%%%%%   color=['r','b','g','magenta','k'];  
   %%%%%%%%%%% line=[1,2,3,4,5];
N=length(line);
   for  i=line                                                                         %%%%%%%%%%%%%%%%%%%%%%��Ҫ����������ȡ����        i=[1,2,3,4,5]
  drawErrorLine_1(times,psth1_mean(i,:),psth1_sem(i,:),color(i),1);   %�������ͼ����������ʱ�䣬ƽ��ֵ��SEM��red��ע,                 
    %%%%%%%%������ǻ�ͼ������Ҫ����   %
   end
legend('aggression', 'loomingfear','female sniff','male sniff','Location','NorthEast') ;% ['aggression', 'loomingfear','female sniff','male sniff','motion','motion'];

plot([-2,4],[0.0,0.0],'--r','LineWidth',2);
plot([0,0],[-0.02,0.05],'--r','LineWidth',2);
hold on;



%title(the_title); %����Ҫ������֣�����                                             
xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');  %��������  
       folder_name = folder_name;  %%
input_csv = 'z_score1.csv'; %%   
psth1=csvread([folder_name, input_csv]);
       else
         ylabel('deltaF/F'); %��������
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