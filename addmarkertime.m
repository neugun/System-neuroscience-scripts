
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


filename1='M:\zzg_fps\170213psi\log20170213-5#right 1_baofeng\';
name1='b.csv';%bite
name2='f.csv';%flee frezzing
name3='s.csv';%%female sniff 
name4='c.csv';%male sniff
name5='m.csv';%move
name6='o.csv';%mount
name7='marker_file.csv';
name=[name1;name2;name3;name4;name5;name6];

                                                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ���һ���������output�ļ��Ľ�������Ȱ��ļ�output.csvͨ���ó���õ��������ô�ѭ����

num=[];
for i=1:1:6  
       infoldername = filename1;
infilename = [infoldername, name(i,:)]; % �ļ���·��
A(i) = exist(infilename, 'file');   %%%%%%%%%%%��� infilename �ļ���ָʾ���ļ����ڣ��� sgc_exist ����2�����򷵻� 0��
if A(i)==2;
folder_name = filename1;  %%
input_csv = name(i,:); %%   
ori=csvread([folder_name, input_csv]);
a=ori(:,1);
else
a=1;  
end
num=[num length(a)]; 
end
n=max(num);
ori_data=zeros(n,6)*1/0; %����������NaN                 
                                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ���϶������ori_data�Ĳ���


for i=1:1:6  
       infoldername = filename1;
infilename = [infoldername, name(i,:)]; % �ļ���·��
A(i) = exist(infilename, 'file');   %%%%%%%%%%%��� infilename �ļ���ָʾ���ļ����ڣ��� sgc_exist ����2�����򷵻� 0��
if A(i)==2;
folder_name = filename1;  %%
input_csv = name(i,:); %%   
ori=csvread([folder_name, input_csv]);
a=ori(:,1);
else
a=1; 
end
ori_data(1:num(i),i)=a;
end

csvwrite(name7,ori_data); % ��������ļ�
