x=0:0.1*pi:2*pi;
y1=sin(x);y2=cos(3*x);y3=sin(x).*cos(3*x);
figure;
plot(x,y1,'ob',x,y2,'--dc',x,y3,':vr')
