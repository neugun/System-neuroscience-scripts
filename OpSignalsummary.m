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
handles.file_path_and_name = fullfile(pathname, filename);                 %%%%% changed by zzg 161223 ����ѧϰ��handles��ֱ�Ӱ�Excel�����ݵõ��ˡ�

if filename == 0
    return;
end

set(handles.edit_file, 'String', handles.file_path_and_name);             

data = csvread(handles.file_path_and_name);                              %%% read CSV file
handles.channelnum=size(data,2);                                            %ͨ����Ŀcolumns  If X = rand(2,3,4) then m2 = size(X,2)(rows and columns)  returns  m2 = 3
handles.length = size(data,1);                                              %ͨ���ĳ���size(X,1) returns the number of rows.
set(handles.pm_cue,'String',num2str((1:1:handles.channelnum-1)'));        %%% ��cue�ĸ����ܶ�
set(handles.pm_cue,'Value',1);                                            %%% ��cue�ĳ�ʼֵΪ1   Set object properties.

for i=1:handles.channelnum-1
    eval(['handles.data',num2str(i),'=','data(:,i)',';']);              %%% eval��ôʹ�ã�Execute string with MATLAB expression.
end

%%%%%% changed by zzg 161223
%�ڿ�ʼ����֮ǰȡzcoreֵ 
for i=handles.channelnum-7:handles.channelnum-1
average=mean(data(:,i));
stdev =std(data(:,i));
data(:,i) = (data(:,i)-average)/stdev ;
data(:,handles.channelnum-8)=(data(:,handles.channelnum-8)+data(:,i))/2;
end  
% ������EMG��delta/theta��
 data(:,handles.channelnum)=abs(data(:,handles.channelnum));%
 
%%%����handles.wave��ǰ���ͼ. 
handles.wave = data(:,handles.channelnum-8); 

%�½�һ������Ϊ��������һ������EMG
handles.DATA1=data(:,handles.channelnum);

cell=[];   
for i=1:handles.length-1                                        %�����Ǽ�һ����Ҫע�����ݵĸ�����
	if handles.data1(i)==0 && handles.data1(i+1)==1        %% handles.data1��ʲô���壿�ǵ�һ���𣿶��ұ���data=1�����ڵ���Ϊ0�������������ֻ��ǵ�һ���̼��ĵ㣬Ҳ������һ��cell>0
		cell(i+1) =1;
	else	
		cell(i+1) =0;
	end
end
handles.upindex=find(cell==1);                               %%%һ����cell==1���У����򲻷��أ�Ҳ������һ��cell>0
trialnum = size(handles.upindex);                             %%%�ܹ��̼��Ĵ�����trialnum  size returns the two-element row vector
handles.trialnum = trialnum(2);                                      %%%����trialnum��???   

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


% --- Executes on button press in pushbuttonDrawAll.                            %%%����DrawAll������ͼ�ε���???
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
% x=1:1:handles.length;                                                    %%%����x����
% ylim([0,1]);
% set(gca,'xtick',[],'ytick',[]) 
% %axis([1 handles.length 0 1]);           % %%%����x���곤��
% stairs(x,handles.data1);               % stairs��һ��һ��cue?   xlim?
% xlim([0,handles.bin]);
% b=axes('position',[.1 .2 .8 0.6],'units','normalized');
% plot(x,handles.wave);                   % %%%����x���곤�Ȼ�ͼ
% xlim([0,handles.bin]);
% 
% uicontrol('units','normalized','Style','slider','pos',[.1 .1 .8 .05],'SliderStep',[handles.scrobin handles.scrobin],...
%     'min',0,'max',handles.scrolength,'callback',{@slider_callback,a,b});
% uicontrol('units','normalized','Style','pushbutton','pos',[.1 .03 .15 .05],'min',0,'max',10,'String', 'Zoomin',...
%     'Callback',{@zoomin_callback,a,b});
% uicontrol('units','normalized','Style','pushbutton','pos',[.3 .03 .15 .05],'min',0,'max',10,'String', 'Zoomout',...
%     'Callback',{@zoomout_callback,a,b});
% guidata(hObject, handles);                         %������������

interval = 1/str2num(get(handles.TB_SampleRate,'String'));             %TB_SampleRate1,interval=1������������
t=interval*(1:1:handles.length);                                     %t=2061s!!!
figure;
for i=1:handles.channelnum-1                                     %handles.channelnum=12��
    subplot(handles.channelnum+2,1,i);                       %������һֱ��ͼ��ʾ��N�е���˼  %subplot 13�У����ΰ�i����ͼ
    eval(['plot(t,handles.data',num2str(i),');']);                          % num2str     eval(EXPRESSION) evaluates the MATLAB code in the string EXPRESSION.
                                                        % H = subplot(m,n,p), or subplot(mnp), breaks the Figure window into an m-by-n matrix of small axes, selects the p-th axes for the current plot, and returns the axes handle.  The axes are counted along the top row of the Figure window, then the second
end
subplot(handles.channelnum+2,1,handles.channelnum:handles.channelnum+2); %subplot 13�У����ΰ�11-13������ͼ������/??��
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




function pushbuttonAverage_Callback(hObject, eventdata, handles)              %%%������������Ĺؼ�������ע������handles��ֵ�Ѿ�������
% hObject    handle to pushbuttonAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning('off');

upindex=handles.upindex;                    %ÿ��eventdataֵ��λ��
trialnum=handles.trialnum;                 %=8
length=handles.length;

trial_from = str2num(get(handles.edit_trial_from,'String'));   %=1
sti1_number = str2num(get(handles.edit_sti1,'String'));     %=����  

basal_time = str2double(get(handles.edit_pre_sti_time,'String'));    %=2
odor_time = str2double(get(handles.edit_post_sti_time,'String'));       %=10
control_time = str2num(get(handles.edit_control_time,'String'));          %=-20      %������Ҫ��ʱ���趨��һ��Ҫע���ʽ�� �������string.    

offset = str2double(get(handles.edit_offset,'String'));            %ע����������ôʹ�õģ�
clims = str2num(get(handles.edit_clims,'String'));
z_score = get(handles.radiobutton_z_score,'Value');                  %ע����������ôʹ�õģ�ֻ�Ƿ����л��ޣ�
heatmap = get(handles.checkbox_heatmap,'Value');
bin = str2double(get(handles.edit_bin,'String'));                % % bin=1s��
interval = 1/str2num(get(handles.TB_SampleRate,'String'));   % interval=1s
if bin<interval                                               % interval=bin
    bin=interval;
    set(handles.edit_bin,'String',num2str(interval));    %Ϊ��һ��Ҫ�����ͬ��ֵ������binһ��Ҫ���ڵ���interval��
end

trialnumtemp = trialnum;
for i=1:trialnum                                       %=8
    if upindex(i) < basal_time      %��ȥ��*100                      %*100 CHANGED BY ZZG
        upindex(i)=0;                                    %�൱��һ������������ָ������event����ǰ����Ŀ���0��ֻ��Ϊ�˷�ֹ��psthʱ-2ǰ��ֵ�����ڣ�����Ϊ��ֵ��
        trialnumtemp = trialnumtemp-1;
    end
end
upindex(upindex==0)=[];                    %������������
trialnum=trialnumtemp;                     %������������
for i =1:trialnum
    if upindex(i)+odor_time>length                       %��ȥ��*100 �� CHANGED BY ZZG��
        upindex(i)=0;                                     %�൱��һ������������ָ������event����ǰ����Ŀ���0��ֻ��Ϊ�˷�ֹ��psthʱ+10ǰ��ֵ�����ڣ�����Ϊ��ֵ��
        trialnumtemp = trialnumtemp-1;
    end
end
trialnum=trialnumtemp;
upindex(upindex==0)=[];
set(handles.edit_sti1, 'String', num2str(trialnum));       %��ʾͣ���ڵ�event������


values = handles.wave;                        
%������ֱ�ӽ�����handles.wave��ֵ���裬����Ҫ��values��ʼʹ��   ��������������values�õ����ֵ���������������ѭ����Ρ�
num = floor(bin/interval);                   %������=1�����������룬����bin/interval=2.3����ֱ��Ϊ2.
M = mod(size(values,1),num);                 % mod(x,y), for x~=y and y~=0, has the same sign as y.����
values = [values;zeros(num-M,1)];            % %��������
values = mean(reshape(values',num,[]),1)';    %����������ȡ���ֵ��ƽ��ֵ
interval = bin;                              %������interval = 1���⼸�������þ�����2ֵʱ�����ǻ�ͼʱֻ�ܻ�һ��ֵ�����Ա�����һ��ֵ����Ҫȡƽ��ֵ��
figure;subplot(2,1,1);
trigger1_times = trigger_times_pretreatment(upindex,trial_from,sti1_number,handles.edit_sti1);  %�õ�trigger1_times����Ҫ����upindex,trial_from,sti1_number,handles.edit_sti1�ĸ�ֵ��       %%%��һ�����б任ʱ�䣬������event��ֵҪ����1(upindex������)

[psth1,psth1_mean,psth1_sem] = psth_wave2(trigger1_times,interval,values,basal_time,odor_time,control_time(1),control_time(2),offset,z_score);  %psth��ͼ����     %�õ�psth����Ҫ����trigger1_times,interval��0.01��,values��Ƶ�ʣ�,basal_time��2��,odor_time��10��,control_time(-2),control_time(0),offset,z_scoreʮ��ֵ









% read ori_csv file
folder_name = 'D:\zzg  processing data\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%
input_csv = 'psth_DATAunit.csv'; %%    
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%����ҪҪ��psth1_mean,psth1_sem�õ���Ȼ��ѵõ���ֵ���ú����drawErrorLine�������ܷ��Լ�����һ������ psthdata
the_title = get(handles.edit_file,'String');  %����
basal_time=psth_DATAunit(1,2);
interval=psth_DATAunit(1,2);
odor_time=interval=psth_DATAunit(1,3);
times = -basal_time:interval:odor_time-interval;  %ʱ���Ǵ�-2��9�����������Ǽ����1
psth1=psth_DATAunit;psth1(3,:)=[];
psth1_mean=mean(psth1);
psth1_sem=std(psth1)/(size(psth1,2)-1)^0.5;          %size(psth1,2)��ʾ���ص�����
drawErrorLine(times,psth1_mean,psth1_sem,'purple',0.5);                               %�������ͼ����������ʱ�䣬ƽ��ֵ��SEM��zise��ע,                  %%%%%%%%������ǻ�ͼ������Ҫ����   %
hold on;
%title(the_title); %����Ҫ������֣�����                                             
%xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');                                                         %�������� z-score
       else
       ylabel('Firing possbility');                                                       %��������
       end
PSTH1=psth1;%���ڻ�heatmap
     

subplot(2,1,2);%figure;   %ԭ����figure��֮��ɾ�� 
% read ori_csv file
folder_name = 'D:\zzg  processing data\MUA\OpSignal-MATLAB-20160712\samplerate=1\';  %%
input_csv = 'psth_DATAemg.csv'; %%    
psth_DATAunit=csvread([folder_name, input_csv]);
% input setup
%����ҪҪ��psth1_mean,psth1_sem�õ���Ȼ��ѵõ���ֵ���ú����drawErrorLine�������ܷ��Լ�����һ������ psthdata
the_title = get(handles.edit_file,'String');  %����
basal_time=psth_DATAunit(1,2);
interval=psth_DATAunit(1,2);
odor_time=interval=psth_DATAunit(1,3);
times = -basal_time:interval:odor_time-interval;  %ʱ���Ǵ�-2��9�����������Ǽ����1
psth1=psth_DATAunit;psth1(3,:)=[];
psth1_mean=mean(psth1);
psth1_sem=std(psth1)/(size(psth1,2)-1)^0.5;          %size(psth1,2)��ʾ���ص�����
drawErrorLine(times,psth1_mean,psth1_sem,'cyan',0.5);                               %�������ͼ����������ʱ�䣬ƽ��ֵ��SEM����ɫ��ע,                  %%%%%%%%������ǻ�ͼ������Ҫ����   %
hold on;
%title(the_title); %����Ҫ������֣�����                                             
%xlabel('Time (s)');
       if z_score==1
       ylabel('z-score');                                                         %�������� z-score
       else
        ylabel('EMG');                                                        %��������
       end
       
PSTH2=psth1;%���ڻ�heatmap
          
  psth1=PSTH1; 
if heatmap
    fig1 = figure;
    subplot(2,1,1);hold on;
    thres = 10;                                                                     %���� thres = 10; 
    heatmapPlot(psth1,interval,basal_time,21:120,1,1:size(psth1,1),0.1,fig1,);                %heatmapPlot��ͼ���� ��Ҫ����psth1��ͼ��ֵ��,interval��0.01��,basal_time��-2��,21:120����������,1,1:size(psth1,1),0.1,fig1,clims=empty
end
%return;   

 psth1=PSTH2;      
if heatmap
    %fig1 = figure;
    subplot(2,1,2);
    thres = 10;                                                                     %���� thres = 10; 
    heatmapPlot(psth1,interval,basal_time,21:120,1,1:size(psth1,1),0.1,fig1,);                %heatmapPlot��ͼ���� ��Ҫ����psth1��ͼ��ֵ��,interval��0.01��,basal_time��-2��,21:120����������,1,1:size(psth1,1),0.1,fig1,clims
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
