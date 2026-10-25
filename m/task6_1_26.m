[X0,Y0,Z0]=sphere(30);
X=2*X0;Y=2*Y0;Z=2*Z0;
figure;
NN=surf(X0,Y0,Z0);
shading interp
hold on
WWW=mesh(X,Y,Z);colormap(hot)
hold off
hidden off
axis equal;axis off
n=12;
for i=1:n
    rotate(NN,[0 0.5 1],25)
    drawnow
    smallFrames(i)=getframe(gcf);
    rotate(WWW,[0.5 0.5 0],25)
    drawnow
    largeFrames(i)=getframe(gcf);
end
movie(smallFrames,5,10)
movie(largeFrames,5,10)
