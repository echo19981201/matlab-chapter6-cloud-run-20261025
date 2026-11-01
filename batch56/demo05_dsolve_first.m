syms x
syms y(x)
solution=dsolve(diff(y,x)==x);
disp('y''=x 的通解');disp(solution)
