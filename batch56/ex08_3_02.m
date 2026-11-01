wn=6;
zeta=0.1;
num=wn^2;
den=[1 2*zeta*wn wn^2];
G=tf(num,den);
display(G)
