%
%rawdata�ֱ�10*9,�����ݷֱ����ǰ���к�����
function  [raw_data,graph,behavior_sum]=aggression_analyze(dataname,raw_data)
         behavior_sum=[];j=1;
for i =1:2:size(raw_data,1)
    behavior_sum.tag(j,:)=raw_data(i,:);
    behavior_sum.timestamps(j,:)=raw_data(i+1,:);
    j=j+1;
end
%%%behavior_sum.tag  behavior_sum.timestamps
%%%find behavior_sum.tag
for i=1:size(raw_data,2)
lones=ones(size(raw_data,1)/2,1);lzeros=zeros(size(raw_data,1)/2,1);
if behavior_sum.tag(:,i)==lones&behavior_sum.timestamps(:,i)==lzeros                                 %LΪ��̼���һ��
    L=i;
end
end
m=size(raw_data,1)/2;n=size(raw_data,2);
bite=[];
latency=[];duration=[];event=[];
for i=1:m
    if sum(behavior_sum.tag(i,:)==2)==0;                                 %%%%�ж��Ƿ���aggression
    latency(i,:)=[15,15,15];
    duration(i,:)=[0,0,0];
    event(i,:)=[0,0,0];
    else
    bite=find(behavior_sum.tag(i,:)==2); 
    bite_first1=bite(bite(:)>L); 
    [~,I]=min(bite_first1(:)-L);
    b_fisrt=bite_first1(I);                                                       %bΪ��̼���һ��
    if max(bite)<L
        latency(i,2)=15; 
    else   
        latency(i,2)=behavior_sum.timestamps(i,b_fisrt);                  %latency(i,2)Ϊ��̼����latency
    end
    
    bite_before=bite(bite(:)<L);                               %bite_beforeΪ��̼�ǰ��bite
    if behavior_sum.timestamps(i,bite(1))==15
    bite_before=bite_before(bite_before~=1);                         %ͨ���˲���ѵ�һ��b=15��ֵɾ����
    bite=bite(bite~=1); 
    end
    bite_after=bite(behavior_sum.timestamps(i,bite(:))>15&behavior_sum.timestamps(i,bite(:))<=30);  
    bite=bite(behavior_sum.timestamps(i,bite(:))<=30);     
    bite_light=[];                                                         %����Ҫ
%     bite_light=find(bite~=bite(bite_before)&bite~=bite(bite_after));     %bite_lightΪ��̼���bite

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ǰ���aggression���������ɸѡ              
    if numel(bite_before)==0&&numel(bite_after)>0  
     bite_light=setxor(bite,bite_after);
    event(i,:)=[0,numel(bite_light),numel(bite_after)]; 
    latency(i,1)=15;duration(i,1)=0;duration2=0;duration3=0;
    latency(i,3)=behavior_sum.timestamps(i,bite_after(1))-15;
    for ii=1:numel(bite_light)                                             %�ȼ��������bite��duration
        if behavior_sum.timestamps(i,bite_light(ii)+1)>15
         duation1=15-behavior_sum.timestamps(i,bite_light(ii)); 
        else
    duation1=behavior_sum.timestamps(i,bite_light(ii)+1)-behavior_sum.timestamps(i,bite_light(ii));
        end
    duration2=duration2+duation1;                                          %���
    end
    duration(i,2)=duration2;                                               %����
     for jj=1:numel(bite_after)                                             %�ȼ��������bite��duration
        if behavior_sum.timestamps(i,bite_after(jj)+1)>30
          duation1=30-behavior_sum.timestamps(i,bite_after(jj));
        else
          duation1=behavior_sum.timestamps(i,bite_after(jj)+1)-behavior_sum.timestamps(i,bite_after(jj));
        end
    duration3=duration3+duation1;                                          %���
    end
    duration(i,3)=duration3;                                               %����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif  numel(bite_after)==0&numel(bite_before)>0 
    bite_light=setxor(bite,bite_before);
    event(i,:)=[numel(bite_before),numel(bite_light),0]; 
    latency(i,3)=15;duration(i,3)=0;duration2=0;duration3=0;
    latency(i,1)=behavior_sum.timestamps(i,max(bite_before));
    for ii=1:numel(bite_before)                                             %�ȼ��������bite��duration
    duation1=behavior_sum.timestamps(i,bite_before(ii))-behavior_sum.timestamps(i,bite_before(ii)+1);
    duration2=duration2+duation1;                                          %���
    end
    duration(i,1)=duration2;                                               %����
     for jj=1:numel(bite_light)                                             %�ȼ��������bite��duration
        if behavior_sum.timestamps(i,bite_light(jj)+1)>15
         duation1=15-behavior_sum.timestamps(i,bite_light(jj)); 
        else
    duation1=behavior_sum.timestamps(i,bite_light(jj)+1)-behavior_sum.timestamps(i,bite_light(jj));
        end
    duration3=duration3+duation1;                                          %���
    end
    duration(i,2)=duration3;                                               %����
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif  numel(bite_before)==0&numel(bite_after)==0 
        bite_light=setxor(bite,bite_after);
        event(i,:)=[0,numel(bite),0]; 
        latency(i,1)=15;latency(i,3)=15;
        duration(i,1)=0;duration(i,3)=0;
        duration2=0;duration3=0;
         for jj=1:numel(bite_light)                                             %�ȼ��������bite��duration
          if behavior_sum.timestamps(i,bite_light(jj)+1)>15
         duation1=15-behavior_sum.timestamps(i,bite_light(jj)); 
        else
    duation1=behavior_sum.timestamps(i,bite_light(jj)+1)-behavior_sum.timestamps(i,bite_light(jj));
        end
         duration2=duration2+duation1;                                          %���
         end
         duration(i,2)=duration2;  
         
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    else numel(bite_before)>0&numel(bite_after)>0      
        latency(i,1)=behavior_sum.timestamps(i,max(bite_before));                %latency(i,1)Ϊ��̼�ǰ��latency    
         latency(i,3)=behavior_sum.timestamps(i,bite_after(1))-15;         %latency(i,1)Ϊ��̼�ǰ��latency 
        bite_light=union(bite_before,bite_after);
        bite_light=setxor(bite,bite_light);
    
    event(i,:)=[numel(bite_before),numel(bite_light),numel(bite_after)];      
    duration2=0;duration3=0;
    for ii=1:numel(bite_before)                                             %�ȼ��������bite��duration
    duation1=behavior_sum.timestamps(i,bite_before(ii))-behavior_sum.timestamps(i,bite_before(ii)+1);
    duration2=duration2+duation1;                                          %���
    end
    duration(i,1)=duration2;  
    for ii=1:numel(bite_light)                                             %�ȼ��������bite��duration
     if behavior_sum.timestamps(i,bite_light(ii)+1)>15
         duation1=15-behavior_sum.timestamps(i,bite_light(ii)); 
        else
    duation1=behavior_sum.timestamps(i,bite_light(ii)+1)-behavior_sum.timestamps(i,bite_light(ii));
        end
    duration2=duration2+duation1;                                          %���
    end
    duration(i,2)=duration2;                                               %����
     for jj=1:numel(bite_after)                                             %�ȼ��������bite��duration
         if behavior_sum.timestamps(i,bite_after(jj)+1)>30
          duation1=30-behavior_sum.timestamps(i,bite_after(jj));
         else
    duation1=behavior_sum.timestamps(i,bite_after(jj)+1)-behavior_sum.timestamps(i,bite_after(jj));
     end
    duration3=duration3+duation1;                                          %���
    end
    duration(i,3)=duration3;  
        
    end 
    %%%%%%%%%%%%%%%%%%%%%%%
    if latency(i,2)>15
        latency(i,2)=15;
        duration(i,2)=0;
            event(i,2)=0;
        if latency(i,2)>30;
           latency(i,3)=15; 
            duration(i,3)=0;
            event(i,3)=0;
        end
    end
    end
end
graph=[];
graph.latency=latency;
graph.duration=duration;
graph.event=event;

fname='graph';%%%%%%%%%%%%%%����mat�ļ���
name1='.mat';
 save([fname,'_',dataname,name1], 'graph');
    
    
  




















