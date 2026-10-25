rng('default')
figure;
subplot(3,1,1)
b=bar(rand(10,5),'stacked');
c=spring(numel(b));
for k=1:numel(b),b(k).FaceColor=c(k,:);end
subplot(3,1,2)
b=bar(0:0.25:1,rand(5),1);
ylim([0 1])
c=spring(numel(b));
for k=1:numel(b),b(k).FaceColor=c(k,:);end
subplot(3,1,3)
b=bar(rand(2,3),0.75,'grouped');
ylim([0 1])
c=spring(numel(b));
for k=1:numel(b),b(k).FaceColor=c(k,:);end
colormap(spring)
