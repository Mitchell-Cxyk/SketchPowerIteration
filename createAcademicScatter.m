%% MATLAB 学术散点图生成函数 (使用 inputParser)
%
% 这个文件包含一个主函数 createAcademicScatter 和一个调用示例。
% 本版本使用 inputParser 对象来处理输入参数，具有最佳的兼容性和稳定性。
%
% 作者: Gemini
% 日期: 2024-05-16 (已修改为 inputParser)
%
% --- 如何使用 ---
% 1. 将本文件保存为 createAcademicScatter.m 到您的MATLAB工作路径下。
% 2. 在您的脚本中，准备好数据矩阵并调用函数:
%    fig = createAcademicScatter(your_data, 'Title', 'My Plot', ...);
% 3. 要运行内置的示例，直接在命令行中执行:
%    createAcademicScatter;

function fig_handle = createAcademicScatter(data, varargin)
% createAcademicScatter: 根据输入数据和选项创建学术风格的散点图
%
% 输入:
%   data: m x n 的数值矩阵。数据格式应为 [x1, y1, x2, y2, ...]
%   varargin: 使用键值对指定的参数。

    % --- 内置示例调用 ---
    if nargin == 0
        disp('正在运行内置示例...');
        clc;
        close all;

        num_points = 50;
        num_groups = 3;
        demo_data = zeros(num_points, 2 * num_groups);
        for i = 1:num_groups
            mean_val = i * 2;
            demo_data(:, (2*i-1):(2*i)) = mean_val + randn(num_points, 2);
        end

        custom_legend = {'Algorithm A', 'Algorithm B', 'Algorithm C'};
        
        h = createAcademicScatter(demo_data, ...
            'Title', 'Comparison of Different Algorithms', ...
            'XLabel', 'Parameter Value (Unit)', ...
            'YLabel', 'Performance Metric (Unit)', ...
            'LegendLabels', custom_legend, ...
            'SavePath', 'scatter_plot_function_output.png');
        
        disp('示例图形已生成并保存！');
        
        if nargout > 0
            fig_handle = h;
        end
        
        return;
    end

    % --- 1. 使用 inputParser 解析输入参数 ---
    p = inputParser;
    
    % --- 定义默认值 ---
    defaultTitle = "Title of the Figure";
    defaultXLabel = "X-axis Label (Unit)";
    defaultYLabel = "Y-axis Label (Unit)";
    defaultLegendLabels = {};
    defaultMarkerStyles = {'o', 's', '^', 'd'};
    defaultColorMap = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250];
    defaultMarkerSize = 8;
    defaultFontName = "Times New Roman";
    defaultAxisFontSize = 12;
    defaultLegendFontSize = 10;
    defaultTitleFontSize = 14;
    defaultAxisLineWidth = 1.2;
    defaultSavePath = "";
    defaultResolution = 300;

    % --- 添加参数规则 ---
    % addRequired(p, 'data', @isnumeric); % data 是必需的
    addParameter(p, 'Title', defaultTitle);
    addParameter(p, 'XLabel', defaultXLabel);
    addParameter(p, 'YLabel', defaultYLabel);
    addParameter(p, 'LegendLabels', defaultLegendLabels, @iscell);
    addParameter(p, 'MarkerStyles', defaultMarkerStyles, @iscell);
    addParameter(p, 'ColorMap', defaultColorMap, @isnumeric);
    addParameter(p, 'MarkerSize', defaultMarkerSize, @isnumeric);
    addParameter(p, 'FontName', defaultFontName);
    addParameter(p, 'AxisFontSize', defaultAxisFontSize, @isnumeric);
    addParameter(p, 'LegendFontSize', defaultLegendFontSize, @isnumeric);
    addParameter(p, 'TitleFontSize', defaultTitleFontSize, @isnumeric);
    addParameter(p, 'AxisLineWidth', defaultAxisLineWidth, @isnumeric);
    addParameter(p, 'SavePath', defaultSavePath);
    addParameter(p, 'Resolution', defaultResolution, @isnumeric);

    % --- 执行解析 ---
    % parse(p, data, varargin{:});
    % 为了兼容更广泛的MATLAB版本，我们直接解析varargin
    parse(p, varargin{:});
    
    % 将解析结果赋值给一个结构体，方便后续调用
    options = p.Results;

    % --- 2. 开始绘图 ---
    fig_handle = figure('Color', 'w');
    ax = gca;
    hold(ax, 'on');

    % --- 循环绘制每个数据组 ---
    [~, n_cols] = size(data);
    num_groups_in_data = n_cols / 2;

    for i = 1:num_groups_in_data
        x_data = data(:, 2*i - 1);
        y_data = data(:, 2*i);
        
        style_idx = mod(i-1, length(options.MarkerStyles)) + 1;
        color_idx = mod(i-1, size(options.ColorMap, 1)) + 1;
        
        scatter(ax, x_data, y_data, options.MarkerSize, ...
            'Marker', options.MarkerStyles{style_idx}, ...
            'MarkerFaceColor', options.ColorMap(color_idx, :), ...
            'MarkerEdgeColor', 'k', ...
            'LineWidth', 0.5);
    end
    hold(ax, 'off');

    % --- 3. 图形美化与调整 ---
    xlabel(ax, options.XLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    ylabel(ax, options.YLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    title(ax, options.Title, 'FontSize', options.TitleFontSize, 'FontName', options.FontName);

    if num_groups_in_data > 1
        legend_labels = options.LegendLabels;
        if isempty(legend_labels)
            legend_labels = cell(1, num_groups_in_data);
            for i = 1:num_groups_in_data
                legend_labels{i} = ['Group ', num2str(i)];
            end
        end
        lgd = legend(ax, legend_labels, 'Location', 'northwest');
        set(lgd, 'FontSize', options.LegendFontSize, 'FontName', options.FontName, 'Box', 'on');
    end

    set(ax, ...
        'Box', 'on', ...
        'LineWidth', options.AxisLineWidth, ...
        'FontName', options.FontName, ...
        'FontSize', options.AxisFontSize, ...
        'TickDir', 'in', ...
        'XMinorTick', 'on', ...
        'YMinorTick', 'on', ...
        'Layer', 'top');

    grid(ax, 'on');
    ax.GridLineStyle = ':';
    ax.GridAlpha = 0.4;

    % --- 4. 导出图形 (如果指定了路径) ---
    if ~isempty(options.SavePath) && strlength(options.SavePath) > 0
        try
            exportgraphics(ax, options.SavePath, 'Resolution', options.Resolution);
        catch ME
            warning('导出图形失败: %s\n尝试使用旧版 print 函数。');
            print(fig_handle, options.SavePath, '-dpng', ['-r', num2str(options.Resolution)]);
        end
    end
end
