% close all
% clc

labelsize = 20;%25;
fontsize = 18;%23;
%% seed data
E = D .* repmat(S',301,1);
gt = sum(E(:,1:46*171),2);
lt = sum(E(:,1+46*171:(46+44)*171),2);
ls = sum(E(:,1+(46+44)*171:(46+44+43)*171),2);

%% endmembers
figure
hold on

plot(y,'k','LineWidth',2)
if ~isempty(members{1})
    plot(gt,'r--','LineWidth',2)
else
    plot(zeros(300,1),'r--','LineWidth',2)
end
if ~isempty(members{2})
    plot(lt,'b--','LineWidth',2)
else
    plot(zeros(300,1),'b--','LineWidth',2)
end
if ~isempty(members{3})
    plot(ls,'Color',[.45 .45 0],'LineStyle','--','LineWidth',2)
else
    plot(zeros(300,1),'Color',[.45 .45 0],'LineStyle','--','LineWidth',2)
end
legend('Signal','GT','LT','LS')
ylim([min(y(1:300))-.5 max(y(1:300))+1.5])
xlim([1 300])
xlabel('Time (300 samples for 30s)', 'Fontsize', labelsize)
set(gca, 'Fontsize', fontsize);
%% reconstruction
figure
hold on

plot(y,'k','LineWidth',2)
plot(D*S,'m--','LineWidth',2);

legend('Signal','Reconstruct')
ylim([min(y(1:300))-.5 max(y(1:300))+1.5])
xlim([1 300])
xlabel('Time (300 samples for 30s)', 'Fontsize', labelsize)
set(gca, 'Fontsize', fontsize);

