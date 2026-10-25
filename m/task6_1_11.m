x=0:0.01:20;
y1=200*exp(-0.05*x).*sin(x);
y2=0.8*exp(-0.5*x).*sin(10*x);
figure;
[AX,H1,H2]=plotyy(x,y1,x,y2,'plot');
set(AX(1),'XColor','k','YColor','b')
set(AX(2),'XColor','k','YColor','r')
HH1=get(AX(1),'YLabel');set(HH1,'String','Left Y-axis','Color','b')
HH2=get(AX(2),'YLabel');set(HH2,'String','Right Y-axis','Color','r')
set(H1,'LineStyle','-','Color','b')
set(H2,'LineStyle',':','Color','r')
legend([H1,H2],{'y1=200*exp(-0.05*x).*sin(x)','y2=0.8*exp(-0.5*x).*sin(10*x)'})
xlabel('Zero to 20 musec.')
title('Labeling plotyy')
