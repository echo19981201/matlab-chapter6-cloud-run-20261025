num=[2 9 1];
den=[1 1 4 4];
[r,p,k]=residue(num,den);
display('留数');display(r)
display('极点');display(p)
display('多项式项');display(k)
[num2,den2]=residue(r,p,k);
display('重构分子系数');display(num2)
display('重构分母系数');display(den2)
