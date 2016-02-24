% clear all
% close all
% clc

data1 = [
    99.54	95.22	9.13
    99.09	95.65	6.09
    98.64	95.65	2.17
    ]/100;

data2 = [
    97.06	88.70	2.61
    99.04	91.30	2.17
    98.64	95.65	2.17
    ]/100;
figure
bar(data1)
set(gca, 'XTick', [1:3])
set(gca, 'XTickLabel', {'Average','Selection','Clustering'})
set(gca, 'YGrid', 'on')
set(gca, 'Fontsize',16)
legend('RPR','DA','FA')

figure
bar(data2)
set(gca, 'XTick', [1:3])
set(gca, 'XTickLabel', {'Average','Selection','Clustering'})
set(gca, 'YGrid', 'on')
set(gca, 'Fontsize',16)
legend('RPR','DA','FA')

    

















