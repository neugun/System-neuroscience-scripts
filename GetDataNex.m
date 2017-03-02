function [output DataType DataTime ]=GetDataNex(fileName,DataParam,timerange)

% output is timestamps of the variable DataParam.Name for event,neuron and marker data; 
%output is the real value for the contionous data

%if output is timestamps,DataType=1;if output is continous data,DataType=sampling rate


% Input DataParam.Name could be both events, neurons or markers type of Nex variable.
%When the variable is event or neurons, it reads out directly the timestamps;
%When the variable is markers in Nex,  then only timestamps of markers
%specified by DataParam.Marker was read out; If there's no subfield of
%DataParam.Marker, all of the timestamps were read out;

% DataType=0;
%  foldername='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001';
%  A =dir(fullfile(foldername,'*.nex')); 
%  nl =length(A);
%  for i=1:nl
%  fname=A(i).name;
% dirname = [foldername,'\',fname];
%  end
%  [nexFile]= readNexFile(dirname); 

output=[];
if isstruct(DataParam)                                                  % isstruct(S) returns logical true (1) if S is a structure and logical false (0) otherwise.
    
   [nexFile] = readNexAll(fileName,DataParam.Name);
else
    
   [nexFile] = readNexAll(fileName,DataParam);

    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面的程序用于将markers程序识别入TS中。
if isfield(nexFile,'markers')                                     %isfield(S,FIELD) returns true if the string FIELD is the name of a field in the structure array S.                           此时需要将markers输入TS，格式是什么？
   TS=nexFile.markers{1}.timestamps;                               %将markers的时间点输入到TS

   if isfield(DataParam,'Marker')
      index=[];                                                   %只识别文件外的marker

      for i=1:length(nexFile.m)                                        %nexFile.m是什么意思？
          if strcmp(nexFile.m(i),DataParam.Marker)                        %%%%%%%% TF = strcmp(S1,S2) compares the strings S1 and S2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise.
              index=[index;i];                                             %当两个文件相同时，记下这些文件所在的序号。
          end
      end
      TS=TS(index);                                                 %将新的值赋予TS。                                                    
   end
   DataType=-1;
   DataTime=timerange(1);                                                 %%%%%%%%%%%%%没有timerange怎么办？假如为（1,100）
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面的几个程序是为了识别文件里是否有events,返回TS, DataType=-1; DataTime=timerange(1)
elseif isfield(nexFile,'events')
   TS=nexFile.events{1}.timestamps;
   DataType=-1;
   DataTime=timerange(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面的几个程序是为了识别文件里是否有neurons,返回TS, DataType=-1; DataTime=timerange(1)
elseif isfield(nexFile,'neurons')
   TS=nexFile.neurons{1}.timestamps;
   DataType=-1;
   DataTime=timerange(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面的几个程序是为了识别文件里是否有contvars,返回TS, data adfreq
elseif isfield(nexFile,'contvars')
   TS=nexFile.contvars{1}.timestamps;
   data=nexFile.contvars{1}.data;
   adfreq=nexFile.contvars{1}.ADFrequency;
   if strcmp(nexFile.contvars{1}.name((end-1):end),'AD')            %%%%%%%%%%%%%%%；用这个程序删除50hz的噪音
      data=Noise50HzRemove(data,adfreq,50);
      data=Noise50HzRemove(data,adfreq,150);

   end
   data=data(:);
   DataType=adfreq;                                                 %%%%%%%%%%%%%当有场电位时需要用到这个程序
%    DataTime=TS+timerange(1);
else
    'unknown variable';
    return; 
end


switch DataType                                                   

    case -1                                                       %%%%%%%%%%%%%%%%这个语句即把上述结果，进行统计，汇总。
    tempTS=[];
        for i=1:length(timerange(1,:))
            tempTS=[tempTS;TS(TS<=timerange(2,i)&TS>=timerange(1,i))];           %tempTS表示返回的时间？使用了一个循环得到TS<=timerange(2,i)
        end

    TS=tempTS;
    output=TS;                                               %%%%%%%%%%%% 最终输出的数据output=TS;  DataType=-1；
    case adfreq                                                  %%%%%%%%%%%%%%adfreq表示采样频率         
        
        timerange=timerange-TS;
        
        tempData=[];
        timerangeI=round(timerange.*adfreq)+1;
        timerangeI(timerangeI<=0)=1;
        timerangeI(timerangeI>length(data))=length(data);
        DataTime=(timerangeI(1,:)-1)/adfreq+TS;
       
        
       for i=1:length(timerangeI(1,:)) 
           data(timerangeI(1,i):timerangeI(2,i));
           
           tempData=[tempData;data(timerangeI(1,i):timerangeI(2,i))];        
       end
           
        output=tempData;
        DataType=adfreq;
    
    otherwise
        
    'checking the data for reading'        
end
        