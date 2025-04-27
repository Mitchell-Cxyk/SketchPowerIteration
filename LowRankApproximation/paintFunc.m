function fig=paintFunc(plotFunc, xMatrix, yMatrix, lineStyles, varargin)
    % paintFunc - 自定义绘图函数，用于绘制多条线并支持颜色、线型和图例控制
    %
    % 输入参数:
    %   plotFunc   - 绘图函数句柄（如 @plot, @semilogy 等），用于实际绘制曲线
    %   xMatrix    - x 坐标矩阵，每行对应一条线的 x 数据
    %   yMatrix    - y 坐标矩阵，每行对应一条线的 y 数据
    %   lineStyles - 线型单元数组（如 {'-', '--', ':'}），指定每条线的样式
    %   varargin   - 可选参数对，支持以下选项：
    %       'DisplayName'   - 单元数组或字符串，指定每条线的图例名称
    %       'LineWidthList' - 单元数组，指定每条线的宽度
    %       'ColorOrder'    - 数值数组，指定颜色索引（从默认颜色列表中选择）
    %
    % 示例用法:
    %   x = 0:0.1:10;
    %   y1 = sin(x); y2 = cos(x);
    %   paintFunc(@plot, x, [y1; y2], {'-', '--'}, ...
    %             'DisplayName', {'sin(x)', 'cos(x)'}, ...
    %             'ColorOrder', [1, 2], ...
    %             'LineWidthList', {2, 1.5});

    % 定义默认颜色顺序（RGB 值）
    defaultColors = {[0, 0.4470, 0.7410], ... % Blue
                     [0.8500, 0.3250, 0.0980], ... % Red-Orange
                     [0.9290, 0.6940, 0.1250], ... % Yellow
                     [0.4940, 0.1840, 0.5560], ... % Purple
                     [0.4660, 0.6740, 0.1880], ... % Green
                     [0.3010, 0.7450, 0.9330], ... % Light Blue
                     [0.6350, 0.0780, 0.1840], ... % Dark Red
                     [0.9020, 0.4470, 0.0745], ... % Orange
                     [0.2157, 0.4706, 0.7490], ... % Teal
                     [0.4196, 0.5569, 0.1373], ... % Olive Green
                     [0.6784, 0.4980, 0.6588], ... % Mauve
                     [0.4118, 0.4118, 0.4118], ... % Dark Gray
                     [0.5451, 0.2706, 0.0745], ... % Brown
                     [0.9412, 0.5020, 0.5020],... % Light Coral
                     [0, 0, 0]};  %Dark 
                     

    % 创建输入解析器，用于处理可选参数
    p = inputParser;
    addParameter(p, 'DisplayName', {}, @(x) iscell(x) || ischar(x) || isstring(x)); % 图例名称，默认空
    addParameter(p, 'LineWidthList', {}, @iscell); % 线宽列表，默认空
    addParameter(p, 'ColorOrder', [], @isnumeric); % 颜色顺序索引，默认空
    parse(p, varargin{:}); % 解析输入参数

    % 提取解析结果
    displayNames = p.Results.DisplayName; % 图例名称
    LineWidthList = p.Results.LineWidthList; % 线宽列表
    colorIndices = p.Results.ColorOrder; % 颜色索引

    % 如果 displayNames 是单一字符串，转换为单元数组以支持多条线
    if ischar(displayNames) || isstring(displayNames)
        displayNames = {displayNames};
    end

    % 计算要绘制的线条数
    numLines = size(xMatrix, 1); % 初始基于 xMatrix 的行数
    if numLines == 1 % 如果 xMatrix 只有一行，则假设它是所有线的共享 x 数据
        numLines = size(yMatrix, 1); % 使用 yMatrix 的行数
        xMatrix = repmat(xMatrix, numLines, 1); % 复制 x 数据以匹配 y 数据
    end

    % 检查输入一致性，确保参数匹配线条数
    if size(xMatrix,2) ~= size(yMatrix,2)
        warning('The xMatrix is not as length as yMatrix, might has truncation!');
    end
    if size(yMatrix, 1) ~= numLines
        error('The number of yMatrix must match the number of lines to be plotted.');
    end
    if ~isempty(displayNames) && length(displayNames) ~= numLines
        error('The number of display names must match the number of lines to be plotted.');
    end
    if ~iscell(lineStyles)
        error('lineStyles must be a cell array.');
    end

    % 处理单一 linestyle 的情况，扩展为每条线都相同
    if numel(lineStyles) == 1
        lineStyles = repmat(lineStyles, numLines, 1);
    end

    % 处理颜色选择
    if isempty(colorIndices)
        % 未提供 ColorOrder 时，按默认顺序使用 defaultColors
        color = defaultColors(1:min(numLines, length(defaultColors)));
    else
        % 使用提供的 ColorOrder 索引从 defaultColors 中选择颜色
        if max(colorIndices) > length(defaultColors) || min(colorIndices) < 1
            error('ColorOrder indices must be within the range of default colors (1 to %d).', length(defaultColors));
        end
        if length(colorIndices) ~= numLines
            error('The number of ColorOrder indices must match the number of lines to be plotted.');
        end
        color = defaultColors(colorIndices);
    end

    % 如果线条数超过颜色数，生成随机颜色补充
    if numLines > length(color)
        for i = length(color)+1:numLines
            color{end+1} = rand(1, 3); % 添加随机 RGB 颜色
        end
    end

    % 如果未提供 LineWidthList，生成默认线宽（从粗到细）
    if isempty(LineWidthList)
        for i = 1:numLines
            LineWidthList{i} = numLines - i + 1; % 默认线宽递减
        end
    end

    % 绘制每条线
    for i = 1:numLines
        % 构造绘图参数列表
        xx=xMatrix(i,:); 
        plotArgs = {xx(xx ~= 0), yMatrix(i, :), lineStyles{i}, ...
                   'Color', color{i}, 'LineWidth', LineWidthList{i}};
        
        % 如果提供了显示名称，添加到绘图参数中
        if ~isempty(displayNames)
            plotArgs = [plotArgs, 'DisplayName', displayNames{i}];
        else
            % 如果没有提供显示名称，关闭该线的图例可见性
            plotArgs = [plotArgs, 'HandleVisibility', 'off'];
        end

        % 调用指定的绘图函数（如 plot）绘制当前线
        plotFunc(plotArgs{:});
        hold on; % 保持图形叠加
    end
    hold off; % 结束叠加模式

    % 如果提供了显示名称，显示图例
    if ~isempty(displayNames)
        legend('show', 'location', 'best'); % 显示图例并自动选择最佳位置
    end
    fig=gcf;
end