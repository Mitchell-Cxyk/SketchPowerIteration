function showFigFiles(varargin)
    % SHOWFIGFILES 显示指定文件夹中所有 .fig 文件
    % 输入：
    %   folderPath - 文件夹路径（字符串）
    
    % 检查输入是否提供
    if nargin < 1
        error('请提供文件夹路径！');
    end
    p = inputParser;
    addParameter(p,'FolderName', {}, @(x) iscell(x) || ischar(x) || isstring(x));
    addParameter(p, 'FileName', {}, @(x) iscell(x) || ischar(x) || isstring(x));
    addParameter(p, 'FileOrder', {}, @isnumeric);
    addParameter(p, 'IsHold', 0, @isnumeric);
    parse(p, varargin{:}); % 解析输入参数

    % 提取解析结果
    FolderName = p.Results.FolderName; % 图例名称
    FileName = p.Results.FileName; % 线宽列表
    FileOrder = p.Results.FileOrder; % 颜色索引
    IsHold = p.Results.IsHold; % 是否保持图形

    if isempty(FolderName)
        error('Please enter Folder Name!');
    end
    folderPath=FolderName;
    % 确保 folderPath 是字符向量或字符串
    if ~ischar(folderPath) && ~isstring(folderPath)
        error('Folder Path must be string!');
    end

    if isempty(FileName)
        % 获取文件夹中所有 .fig 文件
        figFiles = dir(fullfile(folderPath, '*.fig'));
        if isempty(FileOrder)
        FileOrder = 1:length(figFiles);
        end
    else
        for iter=1:numel(FileName)
        figFiles(iter).name = FileName{iter};
        end
        if isempty(FileOrder)
            FileOrder = 1:length(figFiles);
        end
    end

    
    % 检查是否有 .fig 文件
    if isempty(figFiles)
        disp(['文件夹 "', folderPath, '" 中没有找到 .fig 文件！']);
        return;
    end

    figFiles=figFiles(FileOrder);
 
    
    % 按顺序显示所有 .fig 文件
    for k = 1:length(figFiles)
        % 构建完整的文件路径
        fileName = fullfile(folderPath, figFiles(k).name);
        disp(strcat('Now reading ', fileName,'...'));
        % 打开 .fig 文件
        openfig(fileName, 'new', 'visible'); % 'new' 创建新窗口，'visible' 确保显示
        
        % 显示标题（可选）
        % title(['图形 ', num2str(k), ': ', figFiles(k).name],'Interpreter','none');
        currentAxes = gca;
        if contains(class(currentAxes), 'HeatmapChart')
             currentAxes.Title = ['图形 ', num2str(k), ': ', figFiles(k).name];
         else
             title(currentAxes, ['图形 ', num2str(k), ': ', figFiles(k).name], 'Interpreter', 'none');
         end
        
        % 暂停以便查看（可调整时间或改为手动切换）
        % pause(1); % 每张图显示1秒
        % 如果需要手动切换，注释掉 pause(1)，启用以下行：
        waitforbuttonpress;
        
        % 关闭当前图形窗口（可选）
        % 如果不想关闭窗口，注释掉下面这行
        if IsHold==0
        close;
        end
    end
    
    % 显示完成
    disp('所有 .fig 文件显示完毕！');
end