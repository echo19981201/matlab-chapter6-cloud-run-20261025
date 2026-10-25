rng('default')
x=rand(1,10);y=rand(1,10);
z=x.^2+2*y;
figure;
stem3(x,y,z,'filled')
