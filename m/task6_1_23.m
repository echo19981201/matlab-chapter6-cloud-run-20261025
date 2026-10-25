x=-4:4;y=x;
[X,Y]=meshgrid(x,y);
Z=X.^2+Y.^2;
figure;
surf(X,Y,Z);hold on;colormap(hot)
stem3(X,Y,Z,'bo')
