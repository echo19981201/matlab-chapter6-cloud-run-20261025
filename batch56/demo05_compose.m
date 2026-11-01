syms x y z t u
f=1/(1+x^2);
g=sin(y);
h=x^t;
p=exp(-y/u);
result=compose(f,g);
disp('复合函数');disp(result)
