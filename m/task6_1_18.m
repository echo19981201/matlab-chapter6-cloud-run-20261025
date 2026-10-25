x=-5:0.4:5;
y=5:-0.4:-5;
z=exp(-0.2*x).*cos(y);
figure;
plot3(x,y,z,'or',x,y,z)
