s=tf('s');
G=(12*s^3+24*s^2+12*s+20)/(2*s^4+4*s^3+6*s^2+2*s+2);
Gc=(5*s+3)/s;
H=1000/(s+1000);
GG=feedback(G*Gc,H);
display(GG)
