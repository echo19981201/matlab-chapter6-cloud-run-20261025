A=[-1 1;6.5 0];
B=[1 1;1 0];
C=[1 1;1 0];
D=zeros(2,2);
for iu=1:2
[num,den]=ss2tf(A,B,C,D,iu);
for iy=1:2
display(['输入' num2str(iu) ' 到输出' num2str(iy)])
display(tf(num(iy,:),den))
end
end
