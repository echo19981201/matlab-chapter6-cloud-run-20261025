num=[6 12 6 20];
den=[2 4 6 2 2];
G=tf(num,den);
display(G)
disp(G.den{1})
s=tf('s');
G2=(6*s^3+12*s^2+6*s+20)/(2*s^4+4*s^3+6*s^2+2*s+2);
display(G2)
