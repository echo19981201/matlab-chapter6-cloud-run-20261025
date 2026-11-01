syms x
root=vpasolve(1+x==sin(x),x,-2);
disp('方程 1+x=sin(x) 的根');disp(root)
