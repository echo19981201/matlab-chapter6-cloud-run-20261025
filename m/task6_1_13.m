rng('default')
figure;
subplot(3,1,1)
bar(rand(10,5),'stacked')
subplot(3,1,2)
bar(0:0.25:1,rand(5),1)
subplot(3,1,3)
bar(rand(2,3),0.75,'grouped')
ylim([0 1])
