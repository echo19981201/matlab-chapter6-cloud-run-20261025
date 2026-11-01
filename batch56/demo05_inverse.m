syms x y
g1=finverse(1/tan(x),x);
g2=finverse(x^2+y,y);
disp('1/tan(x) 的反函数');disp(g1)
disp('x²+y 关于 y 的反函数');disp(g2)
