syms k n
S=symsum(sym(1)/2^k,k,0,n);
disp('有限和');disp(S)
disp('无穷和');disp(limit(S,n,inf))
