clc;clear;
tagname='tag.txt';%%%%%%��Ҫ��ǰ�趨�ò���
dataname='logVideo47_baofeng_result.csv';
[raw_data]=convert(dataname,tagname);
[raw_data,graph,behavior_sum]=aggression_analyze(dataname,raw_data);
%%%%%%%%%%%%%%�򿪽�����顣