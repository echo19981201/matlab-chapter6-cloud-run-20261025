x=-8:8;
y=x;
[X,Y]=meshgrid(x,y);
Z=sqrt(X.^2+Y.^2);
figure;
subplot(1,2,1),mesh(Z),grid on
subplot(1,2,2),surf(Z),grid on
