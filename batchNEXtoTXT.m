% BatchNextotxt
% 批量处理同一文件夹下的NEX文件，
% 把nex文件中的EEG与EMG信号转为TXT文件，并且采样频率为200hz。
%  foldername='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001';
%  A =dir(fullfile(foldername,'*.nex')); 
%  nl =length(A);
%  for i=1:nl
%  fname=A(i).name;
% dirname = [foldername,'\',fname];
%  end
%  nexFileData = readNexFile(dirname); 

foldername='D:\zzgprocessingdata\MUA\PZ Neuron activity\1109\7dat041415001';

 A =dir(fullfile(foldername,'*.nex'));             % dir directory_name lists the files in a directory. Pathnames and wildcards may be used.  For example, dir *.m lists all program files in the current directory.
                                                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  F = fullfile(FOLDERNAME1, FOLDERNAME2, ..., FILENAME)
 nl =length(A);                                           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  n1 returns all .m
 for i=1:nl
        fname=A(i).name;
       dirname = [foldername,'\',fname];
       point = strfind(fname,'.');             % K = strfind(TEXT,PATTERN) returns the starting indices of any  occurrences of the string PATTERN in the string TEXT.
       newname = fname(1:point-1);       %%%% 文件名
       filename = [foldername,'\',newname,'.txt'];
 nexFileData = readNexFile(dirname);            %%%%%%% [nexFile] = readNexFile(fileName) -- read .nex file and return file data in nexFile structure
 %%%%%%nexFileData是有各种数据的数组。
 EMG = nexFileData.neurons{2}.timestamps;            %%%%%%%%%%需要变化名称。
 EEG = nexFileData.neurons{1}.timestamps;            %%%%%%%%%%需要变化名称。
EEG(:,2)=EMG;        %%
l=length(EMG);
n=1:5:l;
V=EEG(n,:); 
% 
% for i=1:13
% neurons = nexFileData.neurons{i}.timestamps; 
% end
fid=fopen(filename,'wt');                       % 写入文件路径     'w'     open file for writing; discard existing contents
[x,y]=size(V);                                 
for k=1:1:x
for j=1:1:y
if j==y
fprintf(fid,'%f\n',V(k,j));                    % fprintf(FID, FORMAT, A, ...) applies the FORMAT to all elements of array A and any additional array arguments in column order, and writesthe data to a text file.
else
fprintf(fid,'%f\t',V(k,j));                    
end
end
end
fclose(fid);
 end
 
