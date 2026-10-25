x=linspace(0,7);
y1=sin(2*x);
y2=sin(x.^2);
y3=sin(x).^2;
figure;
plot(x,y1,'r+-',x,y2,'k*:',x,y3,'b--^')
