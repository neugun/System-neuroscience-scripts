function drawErrorLine(x,y,error,facecolor,facealpha)
x = x(:)';
y = y(:)';
error = error(:)';

x1 = x;
x2 = fliplr(x);

y1 = y - error;
y2 = fliplr(y + error);

patch([x1 x2],[y1 y2],facecolor,'EdgeColor','none','FaceAlpha',facealpha);
hold on;
h1=plot(x,y,'color',[rand(),rand(),rand()],'LineWidth',2);
% plot([-2,4],[0.0,0.0],'--r','LineWidth',2);
% plot([0,0],[-0.01,0.03],'--r','LineWidth',2);