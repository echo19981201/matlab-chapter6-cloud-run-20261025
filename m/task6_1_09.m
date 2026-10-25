x=0:0.1:5;
y=10*exp(-x).*x.^2;
figure;
subplot(4,2,1);plot(x,y);axis on;title('axis on')
subplot(4,2,2);plot(x,y);axis off;title('axis off')
subplot(4,2,3);plot(x,y);box on;title('box on')
subplot(4,2,4);plot(x,y);box off;title('box off')
subplot(2,1,2);plot(x,y);grid on;title('grid on')
