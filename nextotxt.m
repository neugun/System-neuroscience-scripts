%csript M-file nextotxt
%nextotxt ��nex�ļ��е�EEG��EMG�ź�תΪTXT�ļ������Ҳ���Ƶ��Ϊ200hz��

LFP(:,2)=EMG;
l=length(EMG);
n=1:5:l;
V=LFP(n,:);
fid=fopen('D:\data.txt','wt');% д���ļ�·��
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
