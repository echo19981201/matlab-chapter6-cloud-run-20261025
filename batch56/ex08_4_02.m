num=[0 0 -2;0 -1 -5;1 2 0];
den=[1 6 11 6];
[A,B,C,D]=tf2ss(num,den);
display('状态矩阵 A');display(A)
display('输入矩阵 B');display(B)
display('输出矩阵 C');display(C)
display('直通矩阵 D');display(D)
