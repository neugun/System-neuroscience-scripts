
% [raw_data]=convert('logVideo42_baofeng_result.csv','tag.txt');
% tag中l和b分别为1,2,其他所有的命名为3.
function [raw_data]=convert(data1,tag1)
% tag1='tag.txt';
% data1='logVideo42_baofeng_result.csv';
tagname=tag1;
dataname=data1;
fid = fopen('result.csv', 'w');
[tag,value] = textread(tagname,'%s %f');
content = textread(dataname, '%s', 'delimiter', '\n');
for i=1:length(content)
    str = char(content(i));
    for j=1:length(tag)
        strt = char(tag(j));
        strv = num2str(value(j));
        str = strrep(str,strt,strv);
    end
    content(i)={str};
   raw_data=content;
    fprintf(fid, '%s\n', str);
end
filename1='D:\zzgprocessingdata\MUA\OpSignal-MATLAB-20160712\samplerate=1\dataextract\';  %%%%%%%%%%%%%%%%%%%%%%%%输出
name1='result.csv';
folder_name = filename1;  %%
input_csv =name1; %% 
raw_data={};
raw_data=csvread([folder_name, input_csv]);