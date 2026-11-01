sys=tf(36,[1 6 36]);
[num,den]=tfdata(sys);
display('分子系数');display(num{1})
display('分母系数');display(den{1})
