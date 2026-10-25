x=0:0.1:10;
y=exp(-x);
figure;
subplot(2,2,1);plot(x,y,':r');title('plot')
subplot(2,2,2);semilogx(x,y,'--k');title('semilogx')
subplot(2,2,3);semilogy(x,y,'-.g','LineWidth',1.5);title('semilogy')
subplot(2,2,4);loglog(x,y,':b','LineWidth',0.5);title('loglog')
