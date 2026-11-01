clc;
format short;
disp('一 连续系统的三种数学模型');
numc = [1 3]; denc = [1 3 2];
Gc = tf(numc,denc)
Zc = zpk(-3,[-1 -2],1)
Ac = [0 1;-2 -3]; Bc = [0;1]; Cc = [3 1]; Dc = 0;
Sc = ss(Ac,Bc,Cc,Dc)

disp('二 离散系统的三种数学模型');
Ts = 0.1;
numd = [1 0.2]; dend = [1 -0.7 0.1];
Gd = tf(numd,dend,Ts)
Zd = zpk(-0.2,[0.5 0.2],1,Ts)
Ad = [0 1;-0.1 0.7]; Bd = [0;1]; Cd = [0.2 1]; Dd = 0;
Sd = ss(Ad,Bd,Cd,Dd,Ts)

disp('三 连续系统的模型转换');
Zc1 = zpk(Gc)
Sc1 = ss(Zc1)
Gc1 = tf(Sc1)
[numc1,denc1] = tfdata(Gc1,'v');
disp('转换后的分子系数'); disp(numc1);
disp('转换后的分母系数'); disp(denc1);

disp('四 离散系统的模型转换');
Zd1 = zpk(Gd)
Sd1 = ss(Zd1)
Gd1 = tf(Sd1)
[numd1,dend1] = tfdata(Gd1,'v');
disp('转换后的分子系数'); disp(numd1);
disp('转换后的分母系数'); disp(dend1);
disp('转换后的采样周期'); disp(get(Gd1,'Ts'));
