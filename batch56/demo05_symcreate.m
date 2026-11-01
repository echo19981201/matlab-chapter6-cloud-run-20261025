f1=str2sym('a*x^2+b*x+c');
disp('符号表达式');disp(f1)
syms a b c x
f=a*x^2+b*x+c;
disp(f)
whos a b c x
