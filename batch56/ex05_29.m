syms x y
f=(x^2-2*x)*exp(-x^2-y^2-x*y);
g=simplify(-diff(f,x)/diff(f,y));
disp('隐函数导数 dy/dx');disp(g)
