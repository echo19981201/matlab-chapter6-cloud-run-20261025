x=pi*(0:1000)/1000;
y1=sin(x);
y2=sin(10*x);
y12=sin(x).*sin(10*x);
figure;
subplot(2,2,1),plot(x,y1),axis([0 pi -1 1])
subplot(2,2,2),plot(x,y2),axis([0 pi -1 1])
subplot('position',[0.2 0.05 0.6 0.45])
plot(x,y12),axis([0 pi -1 1])
