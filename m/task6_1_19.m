rng('default')
x=rand(3,10);
figure;
subplot(2,2,1);bar(x);title('bar')
subplot(2,2,2);barh(x,'stacked');title('barh-stacked')
subplot(2,2,3);bar3(x);title('bar3')
subplot(2,2,4);bar3h(x,'stacked');title('bar3h-stacked')
