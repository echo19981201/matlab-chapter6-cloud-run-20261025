syms a x
f1=(exp(x)+x)*(x+2);
f2=a^3-1;
f3=1/a^4+2/a^3+3/a^2+4/a+5;
f4=sin(x)^2+cos(x)^2;
col=collect(f1,x);
disp('合并同类项');disp(col)
disp('展开');disp(expand(f1))
disp('因式分解');disp(factor(f2))
[m,n]=numden(f3);
disp('分子');disp(expand(m))
disp('分母');disp(n)
disp('化简');disp(simplify(f4))
