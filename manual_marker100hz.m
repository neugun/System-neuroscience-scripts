
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����һ�п��ŵ�Marktime��1

clc;
clear;
close all;
filename1='C:\Users\msi~\Desktop\python\thy1\';                 %%%%%%%%%%%%%%%%%%%%%%%%

name1='20170223-thy1_2#_right1.csv';                        %%%%%%%%%%%%%%%%%%%%%%%%

filename2='C:\Users\msi~\Desktop\python\thy1\log20170223-thy1_2#_right1_baofeng\';  %%%%%%%%%%%%%%%%%%%%%%%%
name2='marker_file.csv';%0000000000000000000


filename3=filename2;

name3='lightingcamp.csv';


% read ori_csv file
folder_name = filename1;  %%
csvname=name1;
input_csv =csvname ; %%  
raw_data=csvread([folder_name, input_csv]);

folder_name = filename2;  %%
csvname=name2;
input_csv =csvname ; %%  
marker_data=csvread([folder_name, input_csv]);
                                                                                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ֱ����markerdata��rawdata
folder_name = filename3;  %%
csvname=name3;
input_csv =csvname ; %%  
latency=csvread([folder_name, input_csv]);
latency1=latency(:,4);
latency2=find(latency1==0);
latency1(latency2)=[];
timelapse=mean(latency1);                                                                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1.56sΪ��Ƶ��ʱ��� 
% if timelapse==NaN;
%     timelapse=0;
% end
disp(['timelapse is', ' ',num2str(timelapse),'s']);
                                                                                      


ori_data=zeros(length(raw_data),7);
ori_data(:,7)=raw_data(:,4);                                                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ǰ�����ڵ�����Ϊ����

% input setup
sampleHz=100;bar_interval=100; %%%%%%%changed
total_cal_data=ori_data(:,7); 
len_total=length(total_cal_data);
% plot_data process
total_time=len_total/sampleHz; %unit=s
start_Analysis_time=0;% must>=1 %% A                                                                                       
end_Analysis_time=total_time;                                                                                                                                                                                                                   
disp(['Total GCaMP6 time is', ' ',num2str(total_time),'s']);
disp(['Analysis GCaMP6 time is ',num2str(start_Analysis_time),'s',' - ',num2str(end_Analysis_time),'s']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�ܹ�ʹ������
%k=[5,6];marker_data(:,k)=0;                                                                                    
ori_data(:,1:6)=zeros;                                                                        
for k=1:6
    if marker_data(1,k)==1
    marker_data(1,k)=nan;
end
    a=marker_data(:,k);
    num(:,k)=numel(a)-numel(find(isnan(a)));
    for i=1:num(:,k) 
      %markertime= round(marker_data(i,k))*sampleHz;%-200;-1;                    
      %%%%%%%%%%marker  photometry time *2, round,-200: time shift                
     markertime= round(marker_data(i,k)+timelapse)*sampleHz;                                      %%%%%%%%%%%%ԭ�ȵ�timelapse=gcamp��ʱ��-��Ϊѧ��ʱ�䣬��gcamp��ʱ��=��Ϊѧ��ʱ��+timelapse
     
    for j=1:2      %%%Ϊ����Ҫһ��ѭ����%%%%%%%%%%
       ori_data(markertime+j-1,k)=1;
            %�ڵ�һ�д�marker,Ҳ���Ի�����������
    end
end
end

% % 
% % %                                                                                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���һ���������output�ļ��Ľ�������Ȱ��ļ�output.csvͨ���ó���õ��������ô�ѭ����
% folder_name = 'D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=100\';  %%
% input_csv = 'output.csv'; %%   
% ori_1=csvread([folder_name, input_csv]);
% ori_data=[ori_1;ori_data];
str1='output';
csvname=name1;
csvname=[str1,csvname];                                                                     %%%%%%%%%%%%%%%%���յõ���Ϊoutput20170213-3#left 1.csv���ļ�
csvwrite(csvname,ori_data); % ��������ļ�



