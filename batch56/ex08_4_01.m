num=[0 6 42 72];
den=[1 6 11 6];
sys=tf(num,den);
[z,p,k]=tf2zp(num,den);
[A,B,C,D]=tf2ss(num,den);
syszp=zpk(z,p,k);
display('传递函数');display(sys)
display('零极点模型');display(syszp)
display('零点');display(z)
display('极点');display(p)
display('增益');display(k)
display('状态矩阵 A');display(A)
display('输入矩阵 B');display(B)
display('输出矩阵 C');display(C)
display('直通矩阵 D');display(D)
