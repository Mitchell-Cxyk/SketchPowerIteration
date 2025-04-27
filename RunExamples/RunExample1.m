addpath(genpath('./'));
changeCurrentFolderToScriptFolder;
cd ..;
cd 'TYUC17SPI/';
%%
% Run
mkdir('data');
% example1;
cd '../';
cd 'VerifyPerformance/TYUC17withSPSOracle';
%%
% paint
paintAll;
paintSyneSingularValue;
close all;
% disp('Use enter to show next figure!');
% pause(2);
% showFigFiles('FolderName','figure/');



