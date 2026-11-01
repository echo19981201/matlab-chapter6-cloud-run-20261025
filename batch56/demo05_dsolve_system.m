syms t
syms x(t) y(t)
[xs,ys]=dsolve(diff(x,t)==x+y,diff(y,t)==2*x);
disp('x(t)');disp(xs)
disp('y(t)');disp(ys)
