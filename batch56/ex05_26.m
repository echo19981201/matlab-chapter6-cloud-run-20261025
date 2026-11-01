syms x t
A=[exp(-x) (1+2*t/x)^(3*x)];
disp('极限');disp(limit(A,x,inf))
