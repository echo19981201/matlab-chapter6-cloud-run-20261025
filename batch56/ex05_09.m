syms a b c x
f=a*x^2+b*x+c;
disp('对 x 的一阶导数');disp(diff(f,x))
disp('对 x 的二阶导数');disp(diff(f,x,2))
disp('对 a 的一阶导数');disp(diff(f,a))
disp('对 a 的二阶导数');disp(diff(f,a,2))
disp('混合偏导数');disp(diff(diff(f,a),x))
