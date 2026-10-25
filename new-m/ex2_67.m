t=linspace(0,2*pi,100);
x=1.5*sin(t);
y=3.5*cos(t);
figure;
subplot(2,3,1),plot(x,y),axis normal,grid on,title('Normal and Grid')
subplot(2,3,2),plot(x,y),axis equal,grid on,title('Equal')
subplot(2,3,3),plot(x,y),axis square,grid on,title('Square')
subplot(2,3,4),plot(x,y),axis normal,grid off,title('Grid Off')
subplot(2,3,5),plot(x,y),axis tight,grid off,title('Tight')
subplot(2,3,6),plot(x,y),axis image,grid off,title('Image')
