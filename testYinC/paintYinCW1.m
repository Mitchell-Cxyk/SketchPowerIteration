changeCurrentFolderToScriptFolder();
if ~exist('figure','dir')
    mkdir('figure');
end
figure;
paintTYUCYinCW1('lowrank',0.0001);
xlim([30,150]);
saveas(gcf,'figure/W1/lowrank_0.0001.fig');
figure;
paintTYUCYinCW1('lowrank',0.01);
xlim([30,150]);
saveas(gcf,'figure/W1/lowrank_0.01.fig');
figure;
paintTYUCYinCW1('lowrank',0.1);
xlim([30,150]);
saveas(gcf,'figure/W1/lowrank_0.1.fig');
figure;
paintTYUCYinCW1('poly',0.5);
xlim([30,150]);
saveas(gcf,'figure/W1/poly_0.5.fig');
figure;
paintTYUCYinCW1('poly',1);
xlim([30,150]);
saveas(gcf,'figure/W1/poly_1.fig');
figure;
paintTYUCYinCW1('poly',2);
xlim([60,150]);
saveas(gcf,'figure/W1/poly_2.fig');
figure;
paintTYUCYinCW1('exp',0.01);
xlim([30,150]);
saveas(gcf,'figure/W1/exp_0.01.fig');
figure;
paintTYUCYinCW1('exp',0.1);
xlim([30,110]);
saveas(gcf,'figure/W1/exp_0.1.fig');
figure;
paintTYUCYinCW1('exp',0.5);
xlim([24,55]);
ylim([1e-11,1e2]);
saveas(gcf,'figure/W1/exp_0.5.fig');




