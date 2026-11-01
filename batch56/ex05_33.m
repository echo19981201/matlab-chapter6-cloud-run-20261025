syms t
syms x(t) y(t)
[xs,ys]=dsolve(diff(x,t)==2*x+3*y,diff(y,t)==x-2*y,x(0)==1,y(0)==2);
disp('x(t)');disp(simplify(xs))
disp('y(t)');disp(simplify(ys))
