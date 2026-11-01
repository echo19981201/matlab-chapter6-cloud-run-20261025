s=tf('s');
G=[1/(s+1);s/(s^2+3)];
G.InputDelay=0.3;
display(G)
G2=[1/(s+1);s/(s^2+3)];
G2.IODelay=[0.3;0.3];
display(G2)
