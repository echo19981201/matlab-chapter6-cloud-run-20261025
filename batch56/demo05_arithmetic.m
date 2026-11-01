syms a b
f1=1/(a-b);
f2=2*a/(a+b);
f3=(a+1)*(b-1)*(a-b);
disp('符号和');disp(f1+f2)
disp('符号积');disp(simplify(f1*f3))
disp('符号商');disp(f1/f3)
