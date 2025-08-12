changeCurrentFolderToScriptFolder();
if ~exist('figure','dir')
    mkdir('figure');
end
figure;
paintOracle1('lowrank',0.0001);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.0001.fig');
figure;
paintOracle1('lowrank',0.01);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.01.fig');
figure;
paintOracle1('lowrank',0.1);
xlim([30,150]);
saveas(gcf,'figure/lowrank_0.1.fig');
figure;
paintOracle1('poly',0.5);
xlim([30,150]);
saveas(gcf,'figure/poly_0.5.fig');
figure;
paintOracle1('poly',1);
xlim([30,150]);
saveas(gcf,'figure/poly_1.fig');
figure;
paintOracle1('poly',2);
xlim([60,150]);
saveas(gcf,'figure/poly_2.fig');
figure;
paintOracle1('exp',0.01);
xlim([30,150]);
saveas(gcf,'figure/exp_0.01.fig');
figure;
paintOracle1('exp',0.1);
xlim([30,110]);
saveas(gcf,'figure/exp_0.1.fig');
figure;
paintOracle1('exp',0.5);
xlim([24,70]);
% ylim([1e-15,1e2]);
saveas(gcf,'figure/exp_0.5.fig');




