x=1990:2:2000;
y=[1.25 0.81 2.16 2.73 0.06 0.55];
xin=1990:0.2:2000;
yin=spline(x,y,xin);
figure;
plot(x,y,'ob',xin,yin,'-.r')
title('1990年到2000年某地区年平均降水量图')
xlabel('\it年份','FontSize',15)
ylabel('降雨量','FontSize',8)
