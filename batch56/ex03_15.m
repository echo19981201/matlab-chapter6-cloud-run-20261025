A=[1 0 1;0 1 1;2 3 -5];
B=[1 0;2 1;0 1];
C=[1 1 0];
D=[0 0];
G=ss(A,B,C,D);
Gtf=tf(G);
Gzpk=zpk(G);
display('传递函数');display(Gtf)
display('零极点模型');display(Gzpk)
for iu=1:size(B,2)
[num,den]=ss2tf(A,B,C,D,iu);
G1=tf(num,den);
[z,p,k]=tf2zp(num,den);
G2=zpk(z,p,k);
disp(iu)
display(G1)
display(G2)
end
