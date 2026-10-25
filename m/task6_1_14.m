rng('default')
x=rand(1,5);y=rand(1,5);
figure;
subplot(2,1,1);scatter(x,y);title('散点图')
subplot(2,1,2);comet(x,y);title('彗星图')
