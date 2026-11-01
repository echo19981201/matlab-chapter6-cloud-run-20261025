syms a b x alpha
disp('单变量替换');disp(subs(a+b,a,4))
disp('多变量替换');disp(subs(cos(a)+sin(b),[a b],[alpha 2]))
f=x^2+3*x+2;
disp('x=2 的值');disp(subs(f,x,2))
