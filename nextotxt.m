%csript M-file nextotxt
%nextotxt 把nex文件中的EEG与EMG信号转为TXT文件，并且采样频率为200hz。

LFP(:,2)=EMG;
l=length(EMG);
n=1:5:l;
V=LFP(n,:);
fid=fopen('D:\data.txt','wt');% 写入文件路径
[x,y]=size(V);
for i=1:1:x
for j=1:1:y
if j==y
fprintf(fid,'%f\n',V(i,j));
else
fprintf(fid,'%f\t',V(i,j));
end
end
end
fclose(fid);
