close all;
A = [2.79 7.8 13.85 49.6; 4.67 12.31 22.31 47.8; 4.63 16.81 28.82 62.15; 3.54 7.58 15.29 43.2; 4.9 16.12 28.29 58.7];
B = [1.06 1.22 2.18 20.6; 0.8 4.06 3.85 27.1; 0 3.5 11.4 0; 2.42 2.14 3.66 15; 0 5.68 12.1 0];
U = [2.4 14.3 7.9 33.2; 5.1 4.43 22.4 54.6];
mA = mean(A,1);
mB = mean(B,1);
DA = bsxfun(@minus,A,mA);
DB = bsxfun(@minus,B,mB);
Sw = DA'*DA + DB'*DB;
w = Sw\(mA-mB)';
w = w/norm(w);
threshold = (mA+mB)*w/2;
sA = A*w;
sB = B*w;
sU = U*w;
category = cell(2,1);
for i = 1:2
    if sU(i) >= threshold
        category{i} = '甲地';
    else
        category{i} = '乙地';
    end
    fprintf('未知样本%d判为%s\n',i,category{i});
end
figure('Color','w','Position',[100 100 980 490]);
hold on;
ha = plot(sA,ones(5,1),'bo','MarkerFaceColor','b','MarkerSize',7);
hb = plot(sB,2*ones(5,1),'gs','MarkerFaceColor','g','MarkerSize',7);
hu = plot(sU,3*ones(2,1),'md','MarkerFaceColor','m','MarkerSize',9);
hc = plot([threshold threshold],[0.5 3.5],'k--','LineWidth',1.5);
text(sU(1)+0.3,3.13,['1：' category{1}],'FontSize',11);
text(sU(2)-2.7,2.73,['2：' category{2}],'FontSize',11);
set(gca,'YTick',[1 2 3],'YTickLabel',{'甲地训练样本','乙地训练样本','未知样本'},'FontSize',11);
xlim([-6 17]);
ylim([0.5 3.5]);
xlabel('Fisher 判别投影');
title('两类等先验 Fisher 线性判别');
legend([ha hb hu hc],{'甲地样本','乙地样本','未知样本','判别界限'},'Location','southwest');
grid on;
hold off;
