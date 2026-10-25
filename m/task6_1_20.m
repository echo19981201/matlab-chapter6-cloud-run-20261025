rng('default')
x=rand(1,10);y=rand(1,10);
z=x.^2+y.^2;
figure;
scatter3(x,y,z,36,'r','o')
hold on
[X,Y]=meshgrid(0:0.1:1);
Z=X.^2+Y.^2;
mesh(X,Y,Z)
hidden off
