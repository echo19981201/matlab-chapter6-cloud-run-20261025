[x,y]=meshgrid(-3:0.1:3,-2:0.1:2);
z=(x.^2-2*x).*exp(-x.^2-y.^2-x.*y);
figure;
subplot(221),surf(x,y,z),view(0,90),axis([-3 3 -2 2 -0.8 1.5])
subplot(222),surf(x,y,z),view(90,0),axis([-3 3 -2 2 -0.8 1.5])
subplot(223),surf(x,y,z),view(0,0),axis([-3 3 -2 2 -0.8 1.5])
subplot(224),surf(x,y,z),axis([-3 3 -2 2 -0.8 1.5])
