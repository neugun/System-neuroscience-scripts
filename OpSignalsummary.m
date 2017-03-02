function varargout = OpSignal(varargin)
% OPSIGNAL MATLAB code for OpSignal.fig
%      OPSIGNAL, by itself, creates a new OPSIGNAL or raises the existing
%      singleton*.
%
%      H = OPSIGNAL returns the handle to a new OPSIGNAL or the handle to
%      the existing singleton*.
%
%      OPSIGNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPSIGNAL.M with the given input arguments.
%
%      OPSIGNAL('Property','Value',...) creates a new OPSIGNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OpSignal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OpSignal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OpSignal

% Last Modified by GUIDE v2.5 26-May-2016 09:50:10

% Begin initialization code - DO NOT EDIT
%%%%%changed by zzg 161223
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OpSignal_OpeningFcn, ...
                   'gui_OutputFcn',  @OpSignal_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OpSignal is made visible.
function OpSignal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OpSignal (see VARARGIN)

% Choose default command line output for OpSignal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OpSignal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OpSignal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbuttonLoad.
function pushbuttonLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.CSV', 'Open CSV file');                    %%%Open CSV file
handles.file_path_and_name = fullfile(pathname, filename);                 %%%%% changed by zzg 161223 可以学习其handles，直接把Excel的数据得到了。

if filename == 0
    return;
end

set(handles.edit_file, 'String', handles.file_path_and_name);             

data = csvread(handles.file_path_and_name);                              %%% read CSV file
handles.channelnum=size(data,2);                                            %通道数目columns  If X = rand(2,3,4) then m2 = size(X,2)(rows and columns)  returns  m2 = 3
handles.length = size(data,1);                                              %通道的长度size(X,1) returns the number of rows.
set(handles.pm_cue,'String',num2str((1:1:handles.channelnum-1)'));        %%% 让cue的个数很多
set(handles.pm_cue,'Value',1);                                            %%% 让cue的初始值为1   Set object properties.

for i=1:handles.channelnum-1
    eval(['handles.data',num2str(i),'=','data(:,i)',';']);              %%% eval怎么使用？Execute string with MATLAB expression.
end

%%%%%% changed by zzg 161223
%在开始计算之前取zcore值 
for i=handles.channelnum-7:handles.channelnum-1
average=mean(data(:,i));
stdev =std(data(:,i));
data(:,i) = (data(:,i)-average)/stdev ;
data(:,handles.channelnum-8)=(data(:,handles.channelnum-8)+data(:,i))/2;
end  
% （计算EMG，delta/theta）
 data(:,handles.channelnum)=abs(data(:,handles.channelnum));%
 
%%%利用handles.wave画前面的图. 
handles.wave = data(:,handles.channelnum-8); 

%新建一个矩阵，为了引出另一个数据EMG
handles.DATA1=data(:,handles.channelnum);

cell=[];   
for i=1:handles.length-1                                        %由于是减一，需要注意数据的个数。
	if handles.data1(i)==0 && handles.data1(i+1)==1        %% handles.data1是什么含义？是第一列吗？而且必须data=1，相邻的数为0？这个函数可以只标记第一个刺激的点，也可以试一下cell>0
		cell(i+1) =1;
	else	
		cell(i+1) =0;
	end
end
handles.upindex=find(cell==1);                               %%%一定是cell==1才行，否则不返回，也可以试一下cell>0
trialnum = size(handles.upindex);                             %%%总共刺激的次数，trialnum  size returns the two-element row vector
handles.trialnum = trialnum(2);                                      %%%利用trialnum做???   

set(handles.edit_sti1, 'String', num2str(handles.trialnum));

guidata(hObject, handles);


function edit_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_file as text
%        str2double(get(hObject,'String')) returns contents of edit_file as a double


% --- Executes during object creation, after setting all properties.
function edit_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonDrawAll.                            %%%利用DrawAll做所有图形的线???
function pushbuttonDrawAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDrawAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.f=figure;
% handles.bin = str2num(get(handles.edit_bin,'String'));          %%%%handles.edit_bin=0.01
% handles.scrobin=handles.bin/handles.length;
% handles.scrolength=handles.length-handles.bin;
% 
% a=axes('position',[.1 .9 .8 .05],'units','normalized');
% x=1:1:handles.length;                                                    %%%利用x坐标
% ylim([0,1]);
% set(gca,'xtick',[],'ytick',[]) 
% %axis([1 handles.length 0 1]);           % %%%利用x坐标长度
% stairs(x,handles.data1);               % stairs画一条一条cue?   xlim?
% xlim([0,handles.bin]);
% b=axes('position',[.1 .2 .8 0.6],'units','normalized');
% plot(x,handles.wave);                   % %%%利用x坐标长度画图
% xlim([0,handles.bin]);
% 
% uicontrol('units','normalized','Style','slider','pos',[.1 .1 .8 .05],'SliderStep',[handles.scrobin handles.scrobin],...
%     'min',0,'max',handles.scrolength,'callback',{@slider_callback,a,b});
% uicontrol('units','normalized','Style','pushbutton','pos',[.1 .03 .15 .05],'min',0,'max',10,'String', 'Zoomin',...
%     'Callback',{@zoomin_callback,a,b});
% uicontrol('units','normalized','Style','pushbutton','pos',[.3 .03 .15 .05],'min',0,'max',10,'String', 'Zoomout',...
%     'Callback',{@zoomout_callback,a,b});
% guidata(hObject, handles);                         %？？？？？？

interval = 1/str2num(get(handles.TB_SampleRate,'String'));             %TB_SampleRate1,interval=1？？？？？？
t=interval*(1:1:handles.length);                                     %t=2061s!!!
figure;
for i=1:handles.channelnum-1                                     %handles.channelnum=12？
    subplot(handles.channelnum+2,1,i);                       %就是让一直画图表示画N列的意思  %subplot 13列，依次按i来画图
    eval(['plot(t,handles.data',num2str(i),');']);                          % num2str     eval(EXPRESSION) evaluates the MATLAB code in the string EXPRESSION.
                                                        % H = subplot(m,n,p), or subplot(mnp), breaks the Figure window into an m-by-n matrix of small axes, selects the p-th axes for the current plot, and returns the axes handle.  The axes are counted along the top row of the Figure window, then the second
end
subplot(handles.channelnum+2,1,handles.channelnum:handles.channelnum+2); %subplot 13列，依次按11-13列来画图？？？/??？
plot(t,handles.wave);
xlabel('Time (s)');


function edit_bin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bin as text
%        str2double(get(hObject,'String')) returns contents of edit_bin as a double


% --- Executes during object creation, after setting all properties.
function edit_bin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pushbuttonAverage.




function pushbuttonAverage_Callback(hObject, eventdata, handles)              %%%这是这个函数的关键函数，注意其中handles的值已经给过了
% hObject    handle to pushbuttonAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off');

upindex=handles.upindex;                    %每个eventdata值的位置
trialnum=handles.trialnum;                 %=8
length=handles.length;

trial_from = str2num(get(handles.edit_trial_from,'String'));   %=1
sti1_number = str2num(get(handles.edit_sti1,'String'));     %=？？  

basal_time = str2double(get(handles.edit_pre_sti_time,'String'));    %=2
odor_time = str2double(get(handles.edit_post_sti_time,'String'));       %=10
control_time = str2num(get(handles.edit_control_time,'String'));          %=-20      %三个重要的时间设定，一定要注意格式。 都变成了string.    

offset = str2double(get(handles.edit_offset,'String'));            %注意这两个怎么使用的？
clims = str2num(get(handles.edit_clims,'String'));
z_score = get(handles.radiobutton_z_score,'Value');                  %注意这两个怎么使用的，只是返回有或无？
heatmap = get(handles.checkbox_heatmap,'Value');
bin = str2double(get(handles.edit_bin,'String'));                % % bin=1s？
interval = 1/str2num(get(handles.TB_SampleRate,'String'));   % interval=1s
if bin<interval                                               % interval=bin
    bin=interval;
    set(handles.edit_bin,'String',num2str(interval));    %为何一定要设成相同的值，而且bin一定要大于等于interval。
end

trialnumtemp = trialnum;
for i=1:trialnum                                       %=8
    if upindex(i) < basal_time      %减去了*100                      %*100 CHANGED BY ZZG
        upindex(i)=0;                                    %相当于一个索引个数的指数，把event出现前的数目变成0，只是为了防止做psth时-2前面值不存在，或者为负值。
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];                    %？？？归零吗？
trialnum=trialnumtemp;                     %？？？归零吗？
for i =1:trialnum
    if upindex(i)+odor_time>length                       %减去了*100 （ CHANGED BY ZZG）
        upindex(i)=0;                                     %相当于一个索引个数的指数，把event出现前的数目变成0，只是为了防止做psth时+10前面值不存在，或者为负值。
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum=trialnumtemp;
upindex(upindex==0)=[];
set(handles.edit_sti1, 'String', num2str(trialnum));       %表示停留在的event个数？


values = handles.wave;                        
%？？？直接将上面handles.wave的值赋予，最重要的values开始使用   在这个步骤可以让values得到多个值，或者让这个函数循环多次。
num = floor(bin/interval);                   %？？？=1？？四舍五入，假如bin/interval=2.3，则直接为2.
M = mod(size(values,1),num);                 % mod(x,y), for x~=y and y~=0, has the same sign as y.余数
values = [values;zeros(num-M,1)];            % %？？？？
values = mean(reshape(values',num,[]),1)';    %？？？？，取这个值的平均值
interval = bin;                              %？？？interval = 1，这几部的作用就是有2值时，但是画图时只能画一个值，所以必须用一个值，需要取平均值。
figure;subplot(2,1,1);
trigger1_times = trigger_times_pretreatment(upindex,trial_from,sti1_number,handles.edit_sti1);  %得到trigger1_times，需要输入upindex,trial_from,sti1_number,handles.edit_sti1四个值，       %%%这一步所有变换时间，尤其是event的值要乘以1(upindex不用了)

[psth1,psth1_mean,psth1_sem] = psth_wave2(trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score);  %psth作图方法     %得到psth，需要输入trigger1_times,interval（0.01）,values（频率）,basal_time（2）,odor_time（10）,control_time(-2),control_time(0),offset,z_score十个值









% read ori_csv file
folder_name = 'D:\zzg  processing data\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%
input_csv = 'psth_DATAunit.csv'; %%    
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%最主要要把psth1_mean,psth1_sem得到，然后把得到的值利用后面的drawErrorLine画出。能否自己定义一个函数 psthdata
the_title = get(handles.edit_file,'String');  %标题
basal_time=psth_DATAunit(1,2);
interval=psth_DATAunit(1,2);
odor_time=interval=psth_DATAunit(1,3);
times = -basal_time:interval:odor_time-interval;  %时间是从-2到9？？？，但是间隔是1
psth1=psth_DATAunit;psth1(3,:)=[];
psth1_mean=mean(psth1);
psth1_sem=std(psth1)/(size(psth1,2)-1)^0.5;          %size(psth1,2)表示返回的列数
drawErrorLine(times,psth1_mean,psth1_sem,'purple',0.5);                               %误差线作图方法，输入时间，平均值，SEM，zise标注,                  %%%%%%%%这个才是画图的最主要工具   %
hold on;
%title(the_title); %不需要这个名字，换成                                             
%xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');                                                         %更换标题 z-score
       else
       ylabel('Firing possbility');                                                       %更换标题
       end
PSTH1=psth1;%用于画heatmap
     

subplot(2,1,2);%figure;   %原先有figure，之后删除 
% read ori_csv file
folder_name = 'D:\zzg  processing data\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%
input_csv = 'psth_DATAemg.csv'; %%    
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%最主要要把psth1_mean,psth1_sem得到，然后把得到的值利用后面的drawErrorLine画出。能否自己定义一个函数 psthdata
the_title = get(handles.edit_file,'String');  %标题
basal_time=psth_DATAunit(1,2);
interval=psth_DATAunit(1,2);
odor_time=interval=psth_DATAunit(1,3);
times = -basal_time:interval:odor_time-interval;  %时间是从-2到9？？？，但是间隔是1
psth1=psth_DATAunit;psth1(3,:)=[];
psth1_mean=mean(psth1);
psth1_sem=std(psth1)/(size(psth1,2)-1)^0.5;          %size(psth1,2)表示返回的列数
drawErrorLine(times,psth1_mean,psth1_sem,'cyan',0.5);                               %误差线作图方法，输入时间，平均值，SEM，青色标注,                  %%%%%%%%这个才是画图的最主要工具   %
hold on;
%title(the_title); %不需要这个名字，换成                                             
%xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');                                                         %更换标题 z-score
       else
        ylabel('EMG');                                                        %更换标题
       end
       
PSTH2=psth1;%用于画heatmap
          
  psth1=PSTH1; 
if heatmap
    fig1 = figure;
    subplot(2,1,1);hold on;
    thres = 10;                                                                     %更换 thres = 10; 
    heatmapPlot(psth1,interval,basal_time,21:120,1,1:size(psth1,1),0.1,fig1,);                %heatmapPlot作图方法 需要输入psth1（图的值）,interval（0.01）,basal_time（-2）,21:120（？？？）,1,1:size(psth1,1),0.1,fig1,clims=empty
end
%return;   

 psth1=PSTH2;      
if heatmap
    %fig1 = figure;
    subplot(2,1,2);
    thres = 10;                                                                     %更换 thres = 10; 
    heatmapPlot(psth1,interval,basal_time,21:120,1,1:size(psth1,1),0.1,fig1,);                %heatmapPlot作图方法 需要输入psth1（图的值）,interval（0.01）,basal_time（-2）,21:120（？？？）,1,1:size(psth1,1),0.1,fig1,clims
end
xlabel('Time (s)');
return;





























function edit_trial_from_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial_from as text
%        str2double(get(hObject,'String')) returns contents of edit_trial_from as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sti1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sti1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sti1 as text
%        str2double(get(hObject,'String')) returns contents of edit_sti1 as a double


% --- Executes during object creation, after setting all properties.
function edit_sti1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sti1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_post_sti_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_post_sti_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_post_sti_time as text
%        str2double(get(hObject,'String')) returns contents of edit_post_sti_time as a double


% --- Executes during object creation, after setting all properties.
function edit_post_sti_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_post_sti_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_control_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_control_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_control_time as text
%        str2double(get(hObject,'String')) returns contents of edit_control_time as a double


% --- Executes during object creation, after setting all properties.
function edit_control_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_control_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sampling_rate_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sampling_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sampling_rate as text
%        str2double(get(hObject,'String')) returns contents of edit_sampling_rate as a double


% --- Executes during object creation, after setting all properties.
function edit_sampling_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sampling_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pre_sti_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pre_sti_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pre_sti_time as text
%        str2double(get(hObject,'String')) returns contents of edit_pre_sti_time as a double


% --- Executes during object creation, after setting all properties.
function edit_pre_sti_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pre_sti_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton_z_score.
function radiobutton_z_score_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_z_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_z_score

set(handles.radiobutton_z_score,'Value',1);
set(handles.radiobutton_deltaF,'Value',0);


function edit_offset_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_offset as a double


% --- Executes during object creation, after setting all properties.
function edit_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_clims_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clims as text
%        str2double(get(hObject,'String')) returns contents of edit_clims as a double


% --- Executes during object creation, after setting all properties.
function edit_clims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_heatmap.
function checkbox_heatmap_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_heatmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_heatmap


% --- Executes on selection change in popupmenu_sort.
function popupmenu_sort_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_sort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_sort


% --- Executes during object creation, after setting all properties.
function popupmenu_sort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SD as text
%        str2double(get(hObject,'String')) returns contents of edit_SD as a double


% --- Executes during object creation, after setting all properties.
function edit_SD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_offset as text
%        str2double(get(hObject,'String')) returns contents of edit_offset as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_deltaF.
function radiobutton_deltaF_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_deltaF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_deltaF

set(handles.radiobutton_deltaF,'Value',1);
set(handles.radiobutton_z_score,'Value',0);



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bin as text
%        str2double(get(hObject,'String')) returns contents of edit_bin as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TB_SampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to TB_SampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TB_SampleRate as text
%        str2double(get(hObject,'String')) returns contents of TB_SampleRate as a double


% --- Executes during object creation, after setting all properties.
function TB_SampleRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TB_SampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_controltime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_controltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_controltime as text
%        str2double(get(hObject,'String')) returns contents of edit_controltime as a double


% --- Executes during object creation, after setting all properties.
function edit_controltime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_controltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_evaluationtime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_evaluationtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_evaluationtime as text
%        str2double(get(hObject,'String')) returns contents of edit_evaluationtime as a double


% --- Executes during object creation, after setting all properties.
function edit_evaluationtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_evaluationtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
offset = str2double(get(handles.edit_offset,'String'));
z_score = get(handles.radiobutton_z_score,'Value');
controltime=str2num(get(handles.edit_controltime,'String'));
evaluationtime=str2num(get(handles.edit_evaluationtime,'String'));
interval = 1/str2num(get(handles.TB_SampleRate,'String'));                    %       interval
bin = str2double(get(handles.edit_bin,'String'));
if bin<interval
    bin=interval;
    set(handles.edit_bin,'String',num2str(interval));
end

values = handles.wave;
num = floor(bin/interval);
M = mod(size(values,1),num);
values = [values;zeros(num-M,1)];
values = mean(reshape(values',num,[]),1)';
interval = bin;

controldata=values(round(controltime(1)/interval):round(controltime(2)/interval));
if isempty(evaluationtime)
    evaluationdata=values;
else
    evaluationdata=values(round(evaluationtime(1)/interval):round(evaluationtime(2)/interval));
end

figure;
if z_score==1
    plot(interval*(1:1:length(evaluationdata)),(evaluationdata-mean(controldata))/std(controldata));
    xlabel('Time (s)');
    ylabel('z-score');
else
    plot(interval*(1:1:length(evaluationdata)),(evaluationdata-mean(controldata))/(mean(controldata)-offset));
    xlabel('Time (s)');
    ylabel('F/Hz');%CHANGED BY ZZG
end


% --- Executes on selection change in pm_cue.
function pm_cue_Callback(hObject, eventdata, handles)
% hObject    handle to pm_cue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_cue contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_cue
if isfield(handles,'length')
    cell=[];
    switch get(hObject,'value')
        case 1
            for i=1:handles.length-1
                if handles.data1(i)==0 && handles.data1(i+1)==1
                    cell(i+1) =1;
                else	
                    cell(i+1) =0;
                end
            end
        case 2
            for i=1:handles.length-1
                if handles.data2(i)==0 && handles.data2(i+1)==1
                	cell(i+1) =1;
                else	
                    cell(i+1) =0;
                end
            end
        case 3
            for i=1:handles.length-1
                if handles.data3(i)==0 && handles.data3(i+1)==1
                    cell(i+1) =1;
                else	
                    cell(i+1) =0;
                end
            end
    end
upindex=find(cell==1);
handles.upindex=upindex;
trialnum = size(upindex);
handles.trialnum = trialnum(2);
set(handles.edit_sti1, 'String', num2str(handles.trialnum));
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pm_cue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_cue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
