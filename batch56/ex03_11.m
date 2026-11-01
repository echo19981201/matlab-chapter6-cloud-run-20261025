s=tf('s');
G=1/(s+2)^3;
G.IODelay=2;
T=0.1;
G1=c2d(G,T);
G2=c2d(G,T,'tustin');
disp('零阶保持');display(G1)
disp('双线性变换');display(G2)
