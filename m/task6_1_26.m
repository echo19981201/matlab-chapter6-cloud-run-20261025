[X0,Y0,Z0]=sphere(30);
X=2*X0;Y=2*Y0;Z=2*Z0;
fig=figure;
NN=surf(X0,Y0,Z0);
shading interp
hold on
WWW=mesh(X,Y,Z);colormap(hot)
hold off
hidden off
axis equal;axis off
n=12;
smallFrames=repmat(struct('cdata',[],'colormap',[]),1,n);
largeFrames=repmat(struct('cdata',[],'colormap',[]),1,n);
for i=1:n
    rotate(NN,[0 0.5 1],25)
    drawnow
    smallFrames(i)=getframe(fig);
    rotate(WWW,[0.5 0.5 0],25)
    drawnow
    largeFrames(i)=getframe(fig);
end
movie(fig,smallFrames,5,10)
movie(fig,largeFrames,5,10)
