x=0:2*pi/90:2*pi;
y1=sin(2*x);
figure(1);
plot(x,y1,'r')
figure(2);
y2=exp(-15*x).*sin(2*x);
plot(x,y2,'r')
