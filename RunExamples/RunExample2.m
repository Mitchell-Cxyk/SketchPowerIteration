addpath(genpath('./'));
changeCurrentFolderToScriptFolder;
cd ..;
cd 'realdata/NIST/';
mkdir('data');
mkdir('figure');
if ~exist('NIST20000.mat')
    loadNIST;
else
    load('NIST20000.mat');
end
if ~exist('NIST100k.mat')
    [U,S,V]=svds(imageMatrix20000,100);
    save('NIST100k.mat','U','S','V','-v7.3');
else
    load('NIST100k.mat');
end
mkdir('data');
%%
cd 'figure';
mkdir('NISTSingularValue');


mkdir('NISTSingularVector');
cd 'NISTSingularVector';

mkdir('SingularVectorError');

mkdir('SingularVectorVis');
cd ..;
cd ..;


%
testNIST20000;
paintSingularValues;
close all;
paintMAXErrorOfSV;
close all;
paintSingularVector;
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
% showFigFiles('FolderName','figure/NISTSingularValue/');
% showFigFiles('FolderName','figure/NISTSingularVector/SingularVectorError');
% Pat='NISTSingularVector_T_320_order_';
% showFigFiles('FolderName','figure/NISTSingularVector/SingularVectorVis','FileName',{strcat(Pat,'2','.fig'),strcat(Pat,'3','.fig'),strcat(Pat,'6','.fig')});




