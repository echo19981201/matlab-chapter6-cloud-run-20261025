rng('default')
x=randn(1000,1);y=randn(1000,3);
figure;
subplot(4,1,1);hist(x)
subplot(4,1,2);hist(x,50)
subplot(4,1,3);hist(x,25)
subplot(4,1,4);hist(y,25)
