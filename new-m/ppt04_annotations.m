t=0:0.1:10;
y1=sin(t);
y2=cos(t);
figure;
plot(t,y1,'r',t,y2,'b--');
x=[1.7*pi;1.6*pi];
y=[-0.3;0.7];
s=['sin(t)';'cos(t)'];
text(x,y,s)
title('正弦和余弦曲线')
legend('正弦','余弦')
xlabel('时间')
ylabel('正弦&余弦')
grid on
axis square
