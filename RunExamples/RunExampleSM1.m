addpath(genpath('./'));
changeCurrentFolderToScriptFolder;
cd ..;
cd 'TestMatricesTest/';
mkdir('data');
mkdir('figure');
runTest;
paintFig;
close all;
% disp('Press enter to show first figures. Then press enter to show next');
% figure('MenuBar', 'none', 'ToolBar', 'none', 'Color', 'white');
% axis off;
% text(0.5, 0.5, 'Press enter to show first figures. Then press enter to show next', ...
%     'FontSize', 10, ...
%     'HorizontalAlignment', 'center', ...
%     'VerticalAlignment', 'middle');
% key = waitforbuttonpress;        % Wait for user input
% close all;
% showFigFiles('FolderName','figure/');
