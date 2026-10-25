rng('default')
x=rand(1,10);y=rand(1,10);
z=x.^2+y.^2;
figure;
stem3(x,y,z,'filled')
