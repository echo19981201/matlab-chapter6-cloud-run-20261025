t=0:0.01:4*pi;
r=sin(8*t/3)./(2-cos(3*t/2).^2);
figure;
subplot(1,2,1)
polar(t,r)
axis square
t=0:0.01:6*pi;
r=sin(8*t/3)./(2-cos(3*t/2).^2);
subplot(1,2,2)
polar(t,r)
axis square
