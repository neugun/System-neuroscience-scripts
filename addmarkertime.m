
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

                                                                      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  输出一个包括多个output文件的结果。首先把文件output.csv通过该程序得到，再利用此循环。

num=[];
for i=1:1:6  
       infoldername = filename1;
infilename = [infoldername, name(i,:)]; % 文件的路径
A(i) = exist(infilename, 'file');   %%%%%%%%%%%如果 infilename 文件名指示的文件存在，则 sgc_exist 返回2，否则返回 0。
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
ori_data=zeros(n,6)*1/0; %用无穷大填充NaN                 
                                                                               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 以上都是填充ori_data的步骤


for i=1:1:6  
       infoldername = filename1;
infilename = [infoldername, name(i,:)]; % 文件的路径
A(i) = exist(infilename, 'file');   %%%%%%%%%%%如果 infilename 文件名指示的文件存在，则 sgc_exist 返回2，否则返回 0。
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

csvwrite(name7,ori_data); % 输出打标后文件
