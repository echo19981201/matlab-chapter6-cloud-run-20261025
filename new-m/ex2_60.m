x=0:0.5:4*pi;
y1=exp(-0.1*x).*sin(x);
y2=exp(-0.1*x).*sin(x+1);
figure;
plot(x,y1,x,y2)
