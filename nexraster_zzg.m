% %                20151208 ����code ������firing frequency ����0.5hz��trialɾ����
%                for i=1:length(ts_origin)
%                    if numel(ts_origin(i).data)/(range(2)-range(1))>0.5
%                       ts_origin(i).data=ts_origin_temp(i).data;
%                    end
%                end
%  [onenex]=nexraster_zzg; 
%   INPUT:
%     fileName - if empty string, will use File Open dialog
%   OUTPUT:onenex
%%%%%%%%%%%%%%%
%  foldername='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001';%%%%%%%%%%%%�����������Ĵ������е�NEX���ݣ���ҪԤ��ֵ
%  A =dir(fullfile(foldername,'*.nex')); 
%  nl =length(A);
%  for i=1:nl
%  fname=A(i).name;
% dirname = [foldername,'\',fname];
%  end
% fileName=dirname;
% % %%%%%%%%%%%%%%%%
function [onenex]=nexraster_zzg(fileName) 
clear;
folder_name = 'D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%%%%һ�����m�ļ��ĵ�ַ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read marker_xlsx file                                                                                                                     
input_csv ='marker_file.csv'; %%  
marker_data=csvread([folder_name, input_csv]); %��ǰ����Щʱ���͵������ʱ����ʱ����ƥ�䣬����ȥtimelapse,Ȼ���ɶ���marker,y������ڿ���ת��Ϊһ���ṹ�壬��ס����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%open a folder
if (nargin == 0 | length(fileName) == 0)
   [fname, pathname] = uigetfile('*.nex', 'Select a NeuroExplorer file');
	fileName = strcat(pathname, fname);
end
fid = fopen(fileName, 'r');
if(fid == -1)
   error 'Unable to open file'
   return
end
magic = fread(fid, 1, 'int32');
if magic ~= 827868494
    error 'The file is not a valid .nex file'
end


[nexFile]= readNexFile(fileName);                                          %%%%%%%%%ʹ�������������ֱ�Ӱ�������ȡ������������Щ�����ǲ���Ҫ�ģ���Ҫ��Ϊ���޸�һЩ�ļ�����
timerange=[nexFile.tbeg+10; nexFile.tend];                                  %�ӵ�ʮ�뿪ʼ
range=[-2 4];
bin_width=0.01;                                                            %%%%%%%%%%�����ĸ���������Ԥ��ֵһ�㲻���޸ġ�

%%%%%%%%%%%%%������Ϊѧ������,��Ҫ����һ���ַ��������顣                      %%%%%%%%%%%%%%%��ǰNE����
RefTS=[];                                                                  %%%%%%%%%����neuron��һ�����
num=num2str(1);
nexFile.markers{1, 1}.name=['MK',num];
RefTS=[RefTS;nexFile.markers{1, 1}.name];                                  %%%%%%%%%����marker��һ�����
for i=1:1:size(nexFile.events,1)
    num=num2str(i);
    nexFile.events{i, 1}.name=['EV',num];                                  %%%%%%%%%��Ҫ��events�ı�ǣ�һ���ڹ�̼����õ�
RefTS=[RefTS;nexFile.events{i, 1}.name];
end   
                                                                           %%%%%%%%%%%%�ڵõ�����event��,ֻ��Ҫѡ��1������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RefTSname=RefTS(7,:); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[RefTS DataType DataTime ]=GetDataNex(fileName,RefTSname,timerange);       %%%%%%%%%%�õ��ο���Ϊ��ʱ���

% marker_data=csvread([folder_name, input_csv]); %%%%%%%%%%
id=1;notid=[];
for i=1:size(marker_data,2)-1
if find(marker_data(1,i)>-range(1))                                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%markertime��ʱ��㣬����С��10����ֵ������ȥ��,���к�Ϊid                                                         
    id=[id,i+1]; 
else notid=[notid,i+1];
end
end
length_RefTS=size(id,2);
RefTSname=char(RefTSname,'agg','lof','fsn','msn','bas');                   %%%%%%%%%%%%���вο���Ϊʱ��������
RefTSnamenot=RefTSname(notid,:);                                               %ֻ���������ݵ���
marker =struct(char(RefTSname(1,:)),RefTS,char(RefTSname(2,:)),marker_data(:,1),char(RefTSname(3,:)),marker_data(:,2),char(RefTSname(4,:)),marker_data(:,3),char(RefTSname(5,:)),marker_data(:,4),char(RefTSname(6,:)),marker_data(:,5));
RefTSname=RefTSname(id,:);   
marker=rmfield(marker,RefTSnamenot);                                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���вο���Ϊʱ���      
                       
allDataParam=[];                                                           %%%%%%%%%%%%%������Ԫ������,����һ���ַ��������顣
for i=2:1:size(nexFile.neurons,1)
allDataParam=[allDataParam;nexFile.neurons{i, 1}.name];
end 
 length_Param=size(allDataParam,1);
 rasterA=[];ts_originA=struct([]);
%  RefTSname=fieldnames(marker);
 
 for j=1:length_RefTS                                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ѡ������Ҫ�ο�����Ϊѧ    6����Ϊ
 RefTSname1=RefTSname(j, :);  
%  isfield(marker,RefTSname1)                                     %isfield(S,FIELD) returns true if the string FIELD is the name of a field in the structure array S.                           ��ʱ��Ҫ��markers����TS����ʽ��ʲô��
%    markers(id).timestamps;
RefTSname1=['marker.',RefTSname1];
RefTSname2=eval(RefTSname1);        % eval%%%%%%%%%%%%%%�Ƚ�����marker��һ����ά�ṹ�壬������һ��1*1,Ȼ����1*6   b='marker.';RefTSname1=RefTSname{j, 1};RefTSname1=[b,RefTSname1];RefTSname2=eval(RefTSname1);
%  RefTSname2=RefTSname2(find(RefTSname2>-range(1)));%%%%%%%%%%%%�����в����ϵ�ʱ���ɾ��
for i=1:length_Param
DataParam=allDataParam(i,:);                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���������Ԫ�ŵ��ĳһ�С�
[raster rastertime ts_origin ]=PeriEventRaster_TT(fileName,DataParam,RefTSname2,timerange,range,bin_width);%%%%%%%%%%%%%%%%%%%%%N����Ϊ��rasterʱ���
rasterA(i).timestamps=raster; 
rasterA(i).time=rastertime;
rasterA(i).origin=ts_origin;                                               %%%%%%%%%%%%%%%%%%ts_originA=struct(ts_originA:ts_origin);
 end
 onenex(j).timestamps=rasterA;                                               %%%%%%%%%%%%%���յõ���onenex��������������Ϊ�����ݣ���֮��Ϊÿһ����Ϊ��Ӧ������Ԫ�����ݡ�
 onenex(j).behaviors=marker ;          %�������Ϊѧ��onenex(1, 1).behaviors����ͨ���鿴
 end
% ���н�����ֱ�ӵ�save,���Է���mat
%���ֱ�������Ϊ������Ԫ��Ŀ��trail������
 
 
 





