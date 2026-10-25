z=peaks;
figure;
subplot(2,1,1);contour(z)
subplot(2,1,2);[c,h]=contour(z,[0.8 1.5]);
levels=[0.8 1.5];
labelTargets=[37 40;40 30];
for k=1:numel(levels)
    points=zeros(2,0);
    column=1;
    while column<size(c,2)
        count=c(2,column);
        if abs(c(1,column)-levels(k))<1e-10
            points=[points c(:,column+(1:count))];
        end
        column=column+count+1;
    end
    assert(~isempty(points),'Expected contour level is missing.')
    distance=sum((points-labelTargets(k,:)').^2,1);
    [~,nearest]=min(distance);
    text(points(1,nearest),points(2,nearest),num2str(levels(k)), ...
        'FontSize',9,'Color','k','BackgroundColor','w','Margin',1, ...
        'HorizontalAlignment','center','VerticalAlignment','middle');
end
