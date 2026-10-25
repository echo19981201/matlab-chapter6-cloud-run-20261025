x=0:0.4*pi:2*pi;
y1=sin(x);y2=cos(x);
y3=sin(x-0.1*pi);y4=cos(x+0.1*pi);
figure('Name','6-1-4 图1：plot(y1)');
plot(y1)
figure('Name','6-1-4 图2：plot(x,y1)');
plot(x,y1)
figure('Name','6-1-4 图3：矩阵数据');
plot(x,[y1;y2;y3;y4])
figure('Name','6-1-4 图4：多组数据和图例');
plot(x,y1,x,y2,x,y3,x,y4)
legend('图1','图2','图3','图4')
