x=-5:0.5:5;
y=5.*exp(-abs(x)).*sin(x);
figure;
plot(x,y,'--hr','LineWidth',1.5,'MarkerEdgeColor','b','MarkerFaceColor','m','MarkerSize',10)
