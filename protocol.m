clc;clear;
tagname='tag.txt';%%%%%%需要提前设定好参数
dataname='logVideo47_baofeng_result.csv';
[raw_data]=convert(dataname,tagname);
[raw_data,graph,behavior_sum]=aggression_analyze(dataname,raw_data);
%%%%%%%%%%%%%%打开结果检验。