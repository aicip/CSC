% close all
% clc
% plot the involved endmembers in a multi-event cases.
labelsize = 20;
fontsize = 18;

%% before post-processing
% gt = members_old{1};
% lt = members_old{2};
% ls = members_old{3};
linewidth = 2;
% figure
% hold on
% if ~isempty(gt)
%     stem(gt(:,2),gt(:,1),'r','LineWidth',linewidth);
% end
% if ~isempty(lt)
%     stem(lt(:,2),lt(:,1),'b','LineWidth',linewidth);
% end
% if ~isempty(ls)
%     stem(ls(:,2),ls(:,1),'Color',[.45 .45 0],'LineWidth',linewidth);
% end
% ylabel('Sparse Coefficient', 'Fontsize', labelsize)
% xlabel('Time (s)', 'Fontsize', labelsize)
% set(gca,'YLim',[-.04,1])
% set(gca,'XLim',[0,19])
% set(gca,'XTick',[0:2:19])
% set(gca,'XTickLabel',[0:2:19])
% % legend([h1 h2 h3],'GT','LT','LS')
% h1 = stem(100,0,'r','LineWidth',linewidth);
% h2 = stem(100,0,'b','LineWidth',linewidth);
% h3 = stem(100,0,'Color',[.45 .45 0],'LineWidth',linewidth);
% legend([h1 h2 h3],'GT','LT','LS','Location','Northeast')
% set(gca, 'Fontsize', fontsize);
%% after post-processing
gt = members{1};
lt = members{2};
ls = members{3};

figure
hold on
% h1 = stem(gt(:,2),gt(:,1),'r','LineWidth',1);
% h2 = stem(lt(:,2),lt(:,1),'b','LineWidth',1);
% h3 = stem(ls(:,2),ls(:,1),'Color',[.45 .45 0],'LineWidth',1);
if ~isempty(gt)
    stem(gt(:,2),gt(:,1),'r','LineWidth',linewidth);
end
if ~isempty(lt)
    stem(lt(:,2),lt(:,1),'b','LineWidth',linewidth);
end
if ~isempty(ls)
    stem(ls(:,2),ls(:,1),'Color',[.45 .45 0],'LineWidth',linewidth);
end
ylabel('Sparse Coefficient', 'Fontsize', labelsize)
xlabel('Time (s)', 'Fontsize', labelsize)
set(gca,'YLim',[-.04,1])
set(gca,'XLim',[0,19])
set(gca,'XTick',[0:2:19])
set(gca,'XTickLabel',[0:2:19])
h1 = stem(100,0,'r','LineWidth',linewidth);
h2 = stem(100,0,'b','LineWidth',linewidth);
h3 = stem(100,0,'Color',[.45 .45 0],'LineWidth',linewidth);
legend([h1 h2 h3],'GT','LT','LS','Location','Northeast')
set(gca, 'Fontsize', fontsize);












