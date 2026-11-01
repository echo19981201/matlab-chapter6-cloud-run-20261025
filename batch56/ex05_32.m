syms t
syms y(t)
y0=dsolve(diff(y,t,2)+2*diff(y,t)+2*y==0,y(0)==1,subs(diff(y,t),t,0)==0);
disp('微分方程解');disp(y0)
figure('Color','w');
tt=linspace(-6,5,1000);
yy=double(subs(y0,t,tt));
plot(tt,yy,'b');
title('微分方程的解');xlabel('t');ylabel('y(t)');grid on
