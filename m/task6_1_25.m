x=pi*(-1:0.05:1);y=x;
[X,Y]=meshgrid(x,y);
R=sqrt(X.^2+Y.^2)+eps;
Z=sin(R)./R;
figure;
h=surf(X,Y,Z);colormap(jet)
axis off
n=12;
for i=1:n
    rotate(h,[0 0 1],25)
    drawnow
    frames(i)=getframe(gcf);
end
movie(frames,5,10)
