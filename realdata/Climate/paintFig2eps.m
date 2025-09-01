% 设置文件夹路径
figFolder = 'figureNewPara'; % 替换为你的 .fig 文件所在文件夹路径
outputFolder = 'C:\Users\cxyk3\Documents\Paper-LaTeX\SketchPower\figure\Climate\SingularVector'; % 替换为保存 .eps 文件的文件夹路径

% 确保输出文件夹存在
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 获取文件夹中所有的 .fig 文件
figFiles = dir(fullfile(figFolder, '*.fig'));

% 遍历每个 .fig 文件并转换为 .eps
for i = 1:length(figFiles)
    % 加载 .fig 文件
    figFile = fullfile(figFolder, figFiles(i).name);
    openfig(figFile); % 打开 .fig 文件
    
    % 获取当前图形的句柄
    figHandle = gcf;
    
    % 设置输出文件名
    [~, fileName, ~] = fileparts(figFiles(i).name);
    epsFile = fullfile(outputFolder, [fileName, '.eps']);
    
    % 保存为 .eps 文件
    saveas(figHandle, epsFile, 'epsc'); % 'epsc' 表示彩色 EPS 文件
    
    % 关闭图形
    close(figHandle);
    
    % 打印进度
    fprintf('Converted: %s -> %s\n', figFiles(i).name, epsFile);
end

disp('All .fig files have been converted to .eps files.');