clc;clear;
addpath(genpath('./'));
changeCurrentFolderToScriptFolder;
cd ..;
cd 'realdata'/Climate/;
mkdir('dataNewPara');
mkdir('figureNewPara');
if ~exist('dataMatrix.mat')
    loadnc;
else
    load('dataMatrix.mat');
end
if ~exist('dataMatrixS100.mat')
    [U,S,V]=svds(dataMatrix,100);
    save('dataMatrixS100.mat','U','S','V','-v7.3');
else
    load('dataMatrixS100.mat');
end

mkdir('geoFigure');
testClimateDataNewPara;
paintSingularVectorErrorNewPara;
paintGeo;
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
% showFigFiles('FolderName','figureNewPara');
% showFigFiles('FolderName','geoFigure');

