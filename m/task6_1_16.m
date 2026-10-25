z=peaks;
figure;
subplot(2,1,1);contour(z)
subplot(2,1,2);[c,h]=contour(z,[0.8 1.5]);
labels=clabel(c,h,'LabelSpacing',500,'FontSize',9);
drawnow
labelValues=arrayfun(@(t)str2double(get(t,'String')),labels);
for level=[0.8 1.5]
    ids=find(abs(labelValues-level)<1e-10);
    if numel(ids)>1
        rightmost=-Inf;
        keep=ids(1);
        for j=ids(:)'
            position=get(labels(j),'Position');
            if position(1)>rightmost
                rightmost=position(1);
                keep=j;
            end
        end
        delete(labels(ids(ids~=keep)))
    end
end
