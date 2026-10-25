theta=0:0.05*pi:2*pi;
r1=sin(theta);r2=cos(theta);
figure('Name','6-1-6 单曲线');
polar(theta,r1)
figure('Name','6-1-6 双曲线');
polar([theta' theta'],[r1' r2'])
