% close all
% clc
%plot the reconstruction results for a multi-event case
labelsize = 20;%25;
fontsize = 18;%23;
%% seed data

E = D .* repmat(S',1505,1);
gt = sum(E(:,1:46*171),2);
lt = sum(E(:,1+46*171:(46+47)*171),2);
ls = sum(E(:,1+(46+47)*171:(46+47+43)*171),2);

%% endmembers
figure
hold on
h = [0 0 0 0];

h(1) = plot(y,'k','LineWidth',2);
if ~isempty(members{1})
    h(2) = plot(gt,'r--','LineWidth',2);
else
    %plot(zeros(300,1),'r--','LineWidth',2)
end
if ~isempty(members{2})
    h(3) = plot(lt,'b--','LineWidth',2);
else
    %plot(zeros(300,1),'b--','LineWidth',2)
end
if ~isempty(members{3})
    h(4) = plot(ls,'Color',[.45 .45 0],'LineStyle','--','LineWidth',2);
else
    %plot(zeros(300,1),'Color',[.45 .45 0],'LineStyle','--','LineWidth',2)
end

legends = {
    'Signal'
    'GT'
    'LT'
    'LS'
    };
str = [];
cnt = 1;
for i = 1:length(h)
    
    if h(i) > 0
       str{cnt} =  legends{i};
       cnt = cnt+1;
    end
end
legend(str)
r = 1:301;
ylim([min(y(r))-.5 max(y(r))+1.5])
xlim([r(1) r(end)])
xlabel('Time (300 samples for 30s)', 'Fontsize', labelsize)
set(gca, 'Fontsize', fontsize);
%% reconstruction
figure
hold on

plot(y,'k','LineWidth',2)
plot(D*S,'m--','LineWidth',2);

legend('Signal','Reconstruct')

ylim([min(y(r))-.5 max(y(r))+1.5])
xlim([r(1) r(end)])
xlabel('Time (300 samples for 30s)', 'Fontsize', labelsize)
set(gca, 'Fontsize', fontsize);

