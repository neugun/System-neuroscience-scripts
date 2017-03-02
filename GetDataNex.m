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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ĳ������ڽ�markers����ʶ����TS�С�
if isfield(nexFile,'markers')                                     %isfield(S,FIELD) returns true if the string FIELD is the name of a field in the structure array S.                           ��ʱ��Ҫ��markers����TS����ʽ��ʲô��
   TS=nexFile.markers{1}.timestamps;                               %��markers��ʱ������뵽TS

   if isfield(DataParam,'Marker')
      index=[];                                                   %ֻʶ���ļ����marker

      for i=1:length(nexFile.m)                                        %nexFile.m��ʲô��˼��
          if strcmp(nexFile.m(i),DataParam.Marker)                        %%%%%%%% TF = strcmp(S1,S2) compares the strings S1 and S2 and returns logical 1 (true) if they are identical, and returns logical 0 (false) otherwise.
              index=[index;i];                                             %�������ļ���ͬʱ��������Щ�ļ����ڵ���š�
          end
      end
      TS=TS(index);                                                 %���µ�ֵ����TS��                                                    
   end
   DataType=-1;
   DataTime=timerange(1);                                                 %%%%%%%%%%%%%û��timerange��ô�죿����Ϊ��1,100��
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ļ���������Ϊ��ʶ���ļ����Ƿ���events,����TS, DataType=-1; DataTime=timerange(1)
elseif isfield(nexFile,'events')
   TS=nexFile.events{1}.timestamps;
   DataType=-1;
   DataTime=timerange(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ļ���������Ϊ��ʶ���ļ����Ƿ���neurons,����TS, DataType=-1; DataTime=timerange(1)
elseif isfield(nexFile,'neurons')
   TS=nexFile.neurons{1}.timestamps;
   DataType=-1;
   DataTime=timerange(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ļ���������Ϊ��ʶ���ļ����Ƿ���contvars,����TS, data adfreq
elseif isfield(nexFile,'contvars')
   TS=nexFile.contvars{1}.timestamps;
   data=nexFile.contvars{1}.data;
   adfreq=nexFile.contvars{1}.ADFrequency;
   if strcmp(nexFile.contvars{1}.name((end-1):end),'AD')            %%%%%%%%%%%%%%%�����������ɾ��50hz������
      data=Noise50HzRemove(data,adfreq,50);
      data=Noise50HzRemove(data,adfreq,150);

   end
   data=data(:);
   DataType=adfreq;                                                 %%%%%%%%%%%%%���г���λʱ��Ҫ�õ��������
%    DataTime=TS+timerange(1);
else
    'unknown variable';
    return; 
end


switch DataType                                                   

    case -1                                                       %%%%%%%%%%%%%%%%�����伴���������������ͳ�ƣ����ܡ�
    tempTS=[];
        for i=1:length(timerange(1,:))
            tempTS=[tempTS;TS(TS<=timerange(2,i)&TS>=timerange(1,i))];           %tempTS��ʾ���ص�ʱ�䣿ʹ����һ��ѭ���õ�TS<=timerange(2,i)
        end

    TS=tempTS;
    output=TS;                                               %%%%%%%%%%%% �������������output=TS;  DataType=-1��
    case adfreq                                                  %%%%%%%%%%%%%%adfreq��ʾ����Ƶ��         
        
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
        