changeCurrentFolderToScriptFolder();

mkdir('figure');

figure;
paintStreamingSPI('lowrank',0.0001);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.0001.fig');
figure;
paintStreamingSPI('lowrank',0.01);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.01.fig');
figure;
paintStreamingSPI('lowrank',0.1);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.1.fig');
figure;
paintStreamingSPI('poly',0.5);
xlim([30,150]);
saveas(gcf,'figure/poly_0.5.fig');
figure;
paintStreamingSPI('poly',1);
xlim([30,150]);
saveas(gcf,'figure/poly_1.fig');
figure;
paintStreamingSPI('poly',2);
xlim([60,150]);
saveas(gcf,'figure/poly_2.fig');
figure;
paintStreamingSPI('exp',0.01);
xlim([30,150]);
saveas(gcf,'figure/exp_0.01.fig');
figure;
paintStreamingSPI('exp',0.1);
xlim([30,110]);
saveas(gcf,'figure/exp_0.1.fig');
figure;
paintStreamingSPI('exp',0.5);
xlim([24,65]);
ylim([1e-8,1e2]);
saveas(gcf,'figure/exp_0.5.fig');




