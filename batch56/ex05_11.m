syms a b c x
f=a*x^2+b*x+c;
disp('对 x 的不定积分');disp(int(f,x))
disp('在 0 至 2 对 x 的定积分');disp(int(f,x,0,2))
disp('对 a 的不定积分');disp(int(f,a))
disp('依次对 a、x 积分');disp(int(int(f,a),x))
