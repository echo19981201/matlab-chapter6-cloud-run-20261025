syms a x
disp('双侧极限');disp(limit(1/x,x,0))
disp('左极限');disp(limit(1/x,x,0,'left'))
disp('右极限');disp(limit(1/x,x,0,'right'))
disp('无穷远处极限');disp(limit(((x+a)/(x-a))^x,x,inf))
