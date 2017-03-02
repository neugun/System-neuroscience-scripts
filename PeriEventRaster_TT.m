function [raster rastertime ts_origin ]=PeriEventRaster_TT(fileName,DataParam,RefTS,timerange,range,bin_width)
% range=[-2 4]; range是考虑event前后几秒的数据
%  fileName='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001\7dat041415001.nex';  %dirname
%  DataParam=['TETSPK05a';'TETSPK09a';'TETSPK17a';'TETSPK21a';'TETSPK21b';'TETSPK25a';'TETSPK29a';'TETSPK45a';'TETSPK49a';'TETSPK53a';'TETSPK57a';'TETSPK61a'];% 
%  DataParam=DataParam(2,:);
%  timerange=[1;2000];
% RefPara='EVT20'; %Nex文件中代表event的时间点，比如agression的时间等等
% bin_width=0.01;
% 
% fileName='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001\7dat041415001.nex';  
% timerange=[1;2000];
% range=[-2 4];
% bin_width=0.01;
%  RefTS='EVt';                     %%%%%%%%%%%%%
% [RefTS DataType DataTime]=GetDataNex(fileName,RefTS,timerange);
% DataParam=['TETSPK05a';'TETSPK09a';'TETSPK17a';'TETSPK21a';'TETSPK21b';'TETSPK25a';'TETSPK29a';'TETSPK45a';'TETSPK49a';'TETSPK53a';'TETSPK57a';'TETSPK61a'];% 
% DataParam=DataParam(2,:);
% % 
% % [raster rastertime ts_origin]=PeriEventRaster_TT(fileName,DataParam,RefTS,timerange,range,bin_width);



    [Data DataType DataTime  ]=GetDataNex(fileName,DataParam,[0;100000]);

    
  if isempty(RefTS)
      raster=[];time=[];
      ts_origin=[];                    %%%%%%%代表什么含义
      
      return
      
  end

   ts_origin_temp=[];
   bin_num=round(diff(range)/bin_width); %%%%%%%总共bin的数目
   raster=zeros(length(RefTS),bin_num);  %%%%%%%raster即0或者1
   CorrectIn=1:length(RefTS);            %%%%%%%%%即总共的列数     
   switch DataType                       %%%%%%%%%%%判断前面的数据是场电位或者是放电？
       case 0
       
       case -1               
            for i=1:length(RefTS)       % 
               temp_s=RefTS(i)+range(1);     %(start)
               temp_o=temp_s+bin_num*bin_width; %end
               temp_ts=Data(find(Data>=temp_s&Data<temp_o));%%%%%%将所有在这个6s的时间点全部得到，然后命名为temp_ts
%                temp_ts=[temp_ts;temp_s;temp_o];
               ts_origin(i).data=temp_ts-RefTS(i);          %%%%%%这个ts_origin值为每一个i时每个时间点距离远点的距离
% %                20151208 新添code 用来将firing frequency 低于0.5hz的trial删除掉
%                for i=1:length(ts_origin)
%                    if numel(ts_origin(i).data)/(range(2)-range(1))>0.5
%                       ts_origin(i).data=ts_origin_temp(i).data;
%                    end
%                end
%                %
               if isempty(temp_ts)
               
               else 
                   [raster(i,:),temp_n]=hist(temp_ts,bin_num);      %整行画图吗？ %%%%%%%%  N = hist(Y) bins the elements of Y into 10 equally spaced containers and returns the number of elements in each container.
                                                                     %%%%%%   N = hist(Y,M), where M is a scalar, uses M bins. [N,X] = hist(...) also returns the position of the bin centers in X.
                   raster(i,1)=raster(i,1)-1;                       %%%%%每增加一行，每个值减1. 
                   raster(i,length(raster(i,:)))=raster(i,length(raster(i,:)))-1;  %%%%%每增加一行，每一列的最最后一个值减1. 
                   
%                         end
                    
                    clear temp_index temp_ts temp_n
                end
             end
             rastertime=(range(1)+bin_width/2):bin_width:(bin_width*(bin_num-1)+range(1)+bin_width/2);  %%%%%%%%%%%只是所有列数的横坐标
           
       otherwise                  %%%%%%%%%%%%当数据为场电位时
                  adfreq=DataType;
                  
                  if   bin_width==1/adfreq
                      invalidIn=[];
                       for i=1:length(RefTS)
                          s=1+floor((RefTS(i)+range(1)-DataTime(1))/bin_width);
                          o=s+bin_num-1;
                          if  s<=0||o>length(Data)
                              invalidIn=[invalidIn;i];
                              continue
                          else
                              raster(i,1:bin_num)=Data(s:o);
                          end
                       end
                       CorrectIn(invalidIn)=[];      
                       raster(invalidIn,:)=nan;
                  elseif bin_width>1/adfreq
                        for i=1:length(RefTS)
                            invalidIn=[];
                         bin_width_num=round(bin_width*adfreq);
                         raster_temp_index=zeros(bin_width_num,bin_num);
                         raster_temp=zeros(bin_width_num,bin_num);
                         temp_s=floor((RefTS(i)+range(1)-DataTime(1))*adfreq)+1;
                         temp_o=temp_s+(bin_num-1)*bin_width_num;
                         raster_temp_index(1,:)=temp_s:bin_width_num:temp_o;
                         if temp_s<=0||temp_o>=length(Data)
                            invalidIn=[invalidIn;i]
                            continue
                         end
                         
                         raster_temp(1,:)=Data(raster_temp_index(1,:));
                            for j=2:bin_width_num
                                raster_temp_index(j,:)=raster_temp_index(j-1,:)+1;
                                raster_temp(j,:)=Data(raster_temp_index(j,:));
                            end
                          raster(i,:)=mean(raster_temp);
                 
                        end
                       raster(invalidIn,:)=nan;
                       CorrectIn(invalidIn)=[];
                  else
                      'bin width should not be smaller than sampling period'
                  end      
                 
               rastertime=(range(1)+bin_width/2):bin_width:(bin_width*(bin_num-1)+range(1)+bin_width/2);  
           
           
   end
           
   
   

