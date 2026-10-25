[x,y]=meshgrid(-1:0.1:1);
z=sin(x*pi)+cos(y*pi);
figure;
subplot(2,2,1);surf(x,y,z);title('no light')
subplot(2,2,2);surf(x,y,z)
light('Color','r','Style','infinite','Position',[0 1 2])
title('red infinite light')
subplot(2,2,3);surf(x,y,z)
light('Color','g','Style','infinite','Position',[0 1 2])
title('green infinite light')
subplot(2,2,4);surf(x,y,z)
light('Color','r','Style','local','Position',[0 1 2])
title('red local light')
