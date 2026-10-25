[X0,Y0,Z0]=sphere(30);
X=2*X0;Y=2*Y0;Z=2*Z0;
figure;
surf(X0,Y0,Z0)
shading interp
hold on;mesh(X,Y,Z)
colormap(hot)
hold off
hidden off
axis equal;axis off
