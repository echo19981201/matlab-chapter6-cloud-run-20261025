theta=0:0.05*pi:2*pi;
r1=sin(theta);r2=cos(theta);
figure;
polar([theta' theta'],[r1' r2'])
