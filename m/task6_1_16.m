z=peaks;
figure;
subplot(2,1,1);contour(z)
subplot(2,1,2);[c,h]=contour(z,[0.8 1.5]);clabel(c,h,'LabelSpacing',500,'FontSize',9)
