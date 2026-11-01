z=-2;
p=[0 -1+1i -1-1i];
k=5;
G=zpk(z,p,k);
display(G)
s=zpk('s');
H=5*(s+2)/(s*(s^2+2*s+2));
display(H)
