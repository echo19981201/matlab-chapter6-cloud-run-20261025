t=0:pi/10:2*pi;
y1=sin(t);
y2=cos(t);
y3=sin(t)-cos(t);
figure;
plot(t,y1)
hold on
plot(t,y2)
plot(t,y3)
hold off
