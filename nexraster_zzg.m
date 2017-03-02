% %                20151208 新添code 用来将firing frequency 低于0.5hz的trial删除掉
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
%  foldername='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001';%%%%%%%%%%%%可以批量化的处理其中的NEX数据，需要预设值
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
folder_name = 'D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%%%%一般放在m文件的地址%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read marker_xlsx file                                                                                                                     
input_csv ='marker_file.csv'; %%  
marker_data=csvread([folder_name, input_csv]); %提前将这些时间点和电生理的时间先时间上匹配，即减去timelapse,然后变成多列marker,y尤其后期可以转化为一个结构体，记住名字

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


[nexFile]= readNexFile(fileName);                                          %%%%%%%%%使用这个函数可以直接把数据提取出来，但是有些数据是不需要的，主要是为了修改一些文件名。
timerange=[nexFile.tbeg+10; nexFile.tend];                                  %从第十秒开始
range=[-2 4];
bin_width=0.01;                                                            %%%%%%%%%%上面四个参数都是预设值一般不做修改。

%%%%%%%%%%%%%输入行为学的名称,需要引入一个字符串的数组。                      %%%%%%%%%%%%%%%提前NE分析
RefTS=[];                                                                  %%%%%%%%%混在neuron的一个标记
num=num2str(1);
nexFile.markers{1, 1}.name=['MK',num];
RefTS=[RefTS;nexFile.markers{1, 1}.name];                                  %%%%%%%%%混在marker的一个标记
for i=1:1:size(nexFile.events,1)
    num=num2str(i);
    nexFile.events{i, 1}.name=['EV',num];                                  %%%%%%%%%主要是events的标记，一般在光刺激中用到
RefTS=[RefTS;nexFile.events{i, 1}.name];
end   
                                                                           %%%%%%%%%%%%在得到所有event后，,只需要选择1个即可%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RefTSname=RefTS(7,:); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[RefTS DataType DataTime ]=GetDataNex(fileName,RefTSname,timerange);       %%%%%%%%%%得到参考行为的时间点

% marker_data=csvread([folder_name, input_csv]); %%%%%%%%%%
id=1;notid=[];
for i=1:size(marker_data,2)-1
if find(marker_data(1,i)>-range(1))                                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%markertime的时间点，所有小于10的数值尽可能去除,序列号为id                                                         
    id=[id,i+1]; 
else notid=[notid,i+1];
end
end
length_RefTS=size(id,2);
RefTSname=char(RefTSname,'agg','lof','fsn','msn','bas');                   %%%%%%%%%%%%所有参考行为时间点的名称
RefTSnamenot=RefTSname(notid,:);                                               %只留下有数据的列
marker =struct(char(RefTSname(1,:)),RefTS,char(RefTSname(2,:)),marker_data(:,1),char(RefTSname(3,:)),marker_data(:,2),char(RefTSname(4,:)),marker_data(:,3),char(RefTSname(5,:)),marker_data(:,4),char(RefTSname(6,:)),marker_data(:,5));
RefTSname=RefTSname(id,:);   
marker=rmfield(marker,RefTSnamenot);                                       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%所有参考行为时间点      
                       
allDataParam=[];                                                           %%%%%%%%%%%%%输入神经元的名称,引入一个字符串的数组。
for i=2:1:size(nexFile.neurons,1)
allDataParam=[allDataParam;nexFile.neurons{i, 1}.name];
end 
 length_Param=size(allDataParam,1);
 rasterA=[];ts_originA=struct([]);
%  RefTSname=fieldnames(marker);
 
 for j=1:length_RefTS                                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%选择所有要参考的行为学    6个行为
 RefTSname1=RefTSname(j, :);  
%  isfield(marker,RefTSname1)                                     %isfield(S,FIELD) returns true if the string FIELD is the name of a field in the structure array S.                           此时需要将markers输入TS，格式是什么？
%    markers(id).timestamps;
RefTSname1=['marker.',RefTSname1];
RefTSname2=eval(RefTSname1);        % eval%%%%%%%%%%%%%%先建立的marker是一个多维结构体，首先是一个1*1,然后再1*6   b='marker.';RefTSname1=RefTSname{j, 1};RefTSname1=[b,RefTSname1];RefTSname2=eval(RefTSname1);
%  RefTSname2=RefTSname2(find(RefTSname2>-range(1)));%%%%%%%%%%%%把所有不符合的时间点删除
for i=1:length_Param
DataParam=allDataParam(i,:);                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%输出所有神经元放电的某一列。
[raster rastertime ts_origin ]=PeriEventRaster_TT(fileName,DataParam,RefTSname2,timerange,range,bin_width);%%%%%%%%%%%%%%%%%%%%%N次行为的raster时间点
rasterA(i).timestamps=raster; 
rasterA(i).time=rastertime;
rasterA(i).origin=ts_origin;                                               %%%%%%%%%%%%%%%%%%ts_originA=struct(ts_originA:ts_origin);
 end
 onenex(j).timestamps=rasterA;                                               %%%%%%%%%%%%%最终得到的onenex，首先是六个行为的数据，打开之后为每一个行为对应所有神经元的数据。
 onenex(j).behaviors=marker ;          %具体的行为学在onenex(1, 1).behaviors，可通过查看
 end
% 运行结束后，直接点save,可以返回mat
%最好直接输出行为数，神经元数目，trail次数。
 
 
 





