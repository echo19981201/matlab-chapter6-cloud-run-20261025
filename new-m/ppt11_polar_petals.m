theta=-pi:0.01:pi;
rho=[2*sin(5*theta).^2;
    cos(10*theta).^3;
    sin(theta).^2;
    5*cos(3.5*theta).^3];
for i=1:4
    figure;
    polar(theta,rho(i,:))
end
