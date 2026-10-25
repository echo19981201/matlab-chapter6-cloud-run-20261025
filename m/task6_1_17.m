[X,Y]=meshgrid(-3:0.5:3);
Z=2*X.^2-3*Y.^2;
figure;
subplot(2,2,1);plot(X,Y,'o');title('meshgrid')
subplot(2,2,2);mesh(X,Y,Z);title('mesh')
subplot(2,2,3);surf(X,Y,Z);title('surf')
subplot(2,2,4);surfc(X,Y,Z);title('surfc')
