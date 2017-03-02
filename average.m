[m,n]=size(Heatmap_sorted_data);
for i=1:1;n;
Heatmap_data=mean(Heatmap_sorted_data,i);
end
for j=2:1;m;
Heatmap_sorted_meandata(j,:)=Heatmap_data;
end
 %Heatmap_sorted_data(,j)=Heatmap_data
   %save D:\ Heatmap_sorted_data;
