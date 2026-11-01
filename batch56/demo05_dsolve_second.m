syms t
syms y(t)
solution=dsolve(diff(y,t,2)==1+diff(y,t),y(0)==1,subs(diff(y,t),t,0)==0);
disp('含初始条件的二阶方程解');disp(solution)
