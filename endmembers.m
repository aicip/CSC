close all
clc
gt = members{1};
lt = members{2};
ls = members{3};


figure
hold on
h1 = stem(gt(:,2),gt(:,1),'r','LineWidth',1)
h2 = stem(lt(:,2),lt(:,1),'b','LineWidth',1)
h3 = stem(ls(:,2),ls(:,1),'Color',[.45 .45 0],'LineWidth',1)
ylabel('Sparse Coefficient')
xlabel('Time (s)')
set(gca,'YLim',[-.04,0.8])
set(gca,'XLim',[0,19])
set(gca,'XTick',[0:19])
set(gca,'XTickLabel',[0:19])
legend([h1 h2 h3], 'GT','LT','LS')














