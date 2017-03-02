% rasterparaName=onenex(1, i).timestamps(1, i).origin(1, i) 
%完整的数据为onenex(1, 1).timestamps(1, 4).origin(1, 1).data 
% 需要输入的是i个行为下    某i个神经元的结构体，       而这个结构体还包括1xn(表示i个trail)的子集，          5并且子集后面有一串数据mx1（m表示的是在range中所有的时间点。）
function [an]=plot_raster(structname) 
%最好直接输出行为数，神经元数目，trail次数。
rasterparaName=structname;
figure;
num=size(rasterparaName,2);% number of trials
for jj =1:num
t =rasterparaName(1, jj).data; % Spike timings in the jjth trial
nspikes   = numel(t); % number of elemebts / spikes
for ii = 1:nspikes % for every spike
    line([t(ii) t(ii)],[jj-0.5 jj+0.5],'Color','r'); % draw a black vertical line of length 1 at time t (x) and at trial jj (y)
end
end
xlabel('Time (s)'); % Time is in second
ylabel('Trial');
saveas(gcf, '1.tif'); 
% colormap('jet')



















% figure;
%  xlabel('time/s');
%  ylabel('trial');
%  title('behavior' );
%  y=max(D)/20000;
%  rectangle('Curvature', [0 0], ...) ;
%  for i=1:length(D)-1
%      x=D(i+1)-D(i)
%      if E(i)==0
%          rectangle('Position',[D(i),0,D(i+1)-D(i),y],'LineWidth',2,'LineStyle','-','facecolor','c');
%      elseif E(i)==1 
%          rectangle('Position',[D(i),0,D(i+1)-D(i),y],'LineWidth',2,'LineStyle','-','facecolor','r');
%      else E(i)==2
%         rectangle('Position',[D(i),0,D(i+1)-D(i),y],'LineWidth',2,'LineStyle','-','facecolor','g');
%      end
%  end
%  axis([0,470000,0,400]);
%  set(gca,'box','off','XTick',[],'Ytick',[]);    %去掉上面和右面边框上的刻度 保留边框
% hold on;
% saveas(gcf, '1.tif');    %复制
% 
% legend('boxoff','wake','sleep','rem');
 %去掉matlab图片空白边缘的代码,set(gca,'position',[0 0 1 1])其中[0 01 1]分别距表示left bottom right top的比例，这些可以根据需求调整。





