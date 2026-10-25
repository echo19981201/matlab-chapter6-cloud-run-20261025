x=0:0.1*pi:2*pi;
y1=sin(x);y2=cos(3*x);y3=sin(x).*cos(3*x);
figure('Name','6-1-5 原始曲线属性');
plot(x,y1,'ob',x,y2,'--dc',x,y3,':vr')
figure('Name','6-1-5 修改后的曲线属性');
H=plot(x,y1,'ob',x,y2,'--dc',x,y3,':vr');
set(H(2),'Color','r','LineStyle',':','LineWidth',5)
