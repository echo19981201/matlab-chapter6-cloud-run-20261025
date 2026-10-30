close all;
figure('Color','w','Position',[100 100 700 950]);
axis([0 10 1.2 14.7]);
axis off;
hold on;
nodes = {'开始',sprintf('输入训练样本及其类别标签\n输入待分类样本和 K'),'计算待分类样本与训练样本的距离','选择距离最近的 K 个训练样本','统计近邻类别并进行多数表决','输出预测类别','结束'};
ys = [12.7 10.9 9.1 7.3 5.5 3.7 1.9];
text(5,14.25,'K 近邻分类流程','HorizontalAlignment','center','FontSize',18,'FontWeight','bold');
for i = 1:numel(nodes)
    if i == 1 || i == numel(nodes)
        curve = [1 1];
    else
        curve = [0.08 0.35];
    end
    rectangle('Position',[1 ys(i) 8 1], 'Curvature',curve, 'EdgeColor',[0.2 0.35 0.55], 'FaceColor',[0.95 0.98 1], 'LineWidth',1.5);
    text(5,ys(i)+0.5,nodes{i},'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',13);
    if i < numel(nodes)
        quiver(5,ys(i),0,-0.72,0,'Color',[0.1 0.2 0.3],'LineWidth',1.7,'MaxHeadSize',0.18);
    end
end
hold off;
