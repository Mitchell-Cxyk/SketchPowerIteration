%% MATLAB 学术散点图生成函数 (最终健壮版 + 阴影边界，修正变量名错误)
%
% --- 更新日志 (2025-08-29) ---
% 1. 修复BUG: 修正了上一版代码中因变量名拼写错误导致的程序崩溃问题。
%
% 作者: Gemini
% 日期: 2025-08-29

function fig_handle = createAcademicScatter(data, varargin)
% ... (函数头部注释省略) ...

    % --- 1. 使用 inputParser 解析输入参数 ---
    p = inputParser;
    % ... (默认值定义未变) ...
    defaultBoundaryType = 'none';
    validBoundaryTypes = {'none', 'convex', 'concave', 'shaded'};
    defaultNumBins = 20;
    defaultShadedColor = [0.5, 0.5, 0.5];
    defaultShadedAlpha = 0.2;
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
    defaultBoundaryColor = [0.3, 0.3, 0.3]; 
    defaultBoundaryWidth = 1.5;

    % ... (参数规则定义未变) ...
    addParameter(p, 'BoundaryType', defaultBoundaryType, @(x) any(validatestring(x, validBoundaryTypes)));
    addParameter(p, 'BoundaryColor', defaultBoundaryColor);
    addParameter(p, 'BoundaryWidth', defaultBoundaryWidth, @isnumeric);
    addParameter(p, 'NumBins', defaultNumBins, @isnumeric);
    addParameter(p, 'ShadedColor', defaultShadedColor);
    addParameter(p, 'ShadedAlpha', defaultShadedAlpha, @isnumeric);
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
    parse(p, varargin{:});
    options = p.Results;
    
    fig_handle = figure('Color', 'w');
    ax = gca;
    hold(ax, 'on');

    % --- 提前进行数据清洗和准备 ---
    all_x = data(:, 1:2:end); all_y = data(:, 2:2:end);
    all_x = all_x(:); all_y = all_y(:);
    is_valid = ~(isnan(all_x) | isinf(all_x) | isnan(all_y) | isinf(all_y));
    all_x_cleaned = all_x(is_valid);
    all_y_cleaned = all_y(is_valid);

    % --- 2. 绘制边界/阴影 ---
    if ~strcmpi(options.BoundaryType, 'none') && numel(all_x_cleaned) >= 3
        switch lower(options.BoundaryType)
            case 'shaded'
                min_x_val = min(all_x_cleaned);
                max_x_val = max(all_x_cleaned);
                bin_edges = linspace(min_x_val, max_x_val, options.NumBins + 1);
                bin_edges(end) = max_x_val; 
                [~, bin_indices] = histc(all_x_cleaned, bin_edges);

                upper_boundary = NaN(1, options.NumBins);
                lower_boundary = NaN(1, options.NumBins);
                bin_centers_for_plot = NaN(1, options.NumBins);

                for k = 1:options.NumBins
                    points_in_bin_idx = (bin_indices == k);
                    if any(points_in_bin_idx)
                        y_in_bin = all_y_cleaned(points_in_bin_idx);
                        x_in_bin = all_x_cleaned(points_in_bin_idx);
                        upper_boundary(k) = max(y_in_bin);
                        lower_boundary(k) = min(y_in_bin);
                        bin_centers_for_plot(k) = mean(x_in_bin);
                    end
                end
                
                % 【修正点】使用正确的变量名 bin_centers_for_plot
                valid_bins = ~isnan(bin_centers_for_plot); 
                bin_centers_for_plot = bin_centers_for_plot(valid_bins);
                upper_boundary = upper_boundary(valid_bins);
                lower_boundary = lower_boundary(valid_bins);
                
                if numel(bin_centers_for_plot) < 2
                     warning('有效分箱数据点不足，无法绘制阴影边界。');
                else
                    fill_x = [bin_centers_for_plot, fliplr(bin_centers_for_plot)];
                    fill_y = [upper_boundary, fliplr(lower_boundary)];
                    fill(ax, fill_x, fill_y, options.ShadedColor, ...
                         'FaceAlpha', options.ShadedAlpha, 'EdgeColor', 'none');
                    plot(ax, bin_centers_for_plot, upper_boundary, 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                    plot(ax, bin_centers_for_plot, lower_boundary, 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                end
            
            case 'convex'
                k = convhull(all_x_cleaned, all_y_cleaned);
                plot(ax, all_x_cleaned(k), all_y_cleaned(k), 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
            
            case 'concave'
                try
                    unique_points = unique([all_x_cleaned, all_y_cleaned], 'rows');
                    num_unique_points = size(unique_points, 1);
                    is_collinear = false;
                    if num_unique_points >= 3, is_collinear = rank(bsxfun(@minus, unique_points, mean(unique_points))) < 2; end
                    if num_unique_points < 3 || is_collinear
                        warning('数据点呈线性分布或唯一数据点少于3个，无法计算凹包。已自动回退到绘制凸包边界。');
                        k = convhull(all_x_cleaned, all_y_cleaned);
                        plot(ax, all_x_cleaned(k), all_y_cleaned(k), 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth, 'LineStyle', '--');
                    else
                        shp = alphaShape(all_x_cleaned, all_y_cleaned);
                        shp.Alpha = shp.criticalAlpha('one-region');
                        plot(ax, shp, 'FaceColor', 'none', 'EdgeColor', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                    end
                catch ME, warning(ME.identifier, '计算 alpha shape 边界时发生未知错误: %s', ME.message); end
        end
    elseif ~strcmpi(options.BoundaryType, 'none')
         warning('有效数据点不足3个，无法计算外围边界。');
    end

    % --- 3. 绘制散点 (在边界之上) ---
    [~, n_cols] = size(data);
    num_groups_in_data = n_cols / 2;
    for i = 1:num_groups_in_data
        x_data = data(:, 2*i - 1);
        y_data = data(:, 2*i);
        if isempty(varargin), style_idx = 1; color_idx = 1;
        else
            style_idx = mod(i-1, length(options.MarkerStyles)) + 1;
            color_idx = mod(i-1, size(options.ColorMap, 1)) + 1;
        end
        scatter(ax, x_data, y_data, options.MarkerSize, 'filled', ...
            'Marker', options.MarkerStyles{style_idx}, ...
            'MarkerFaceColor', options.ColorMap(color_idx, :), ...
            'MarkerEdgeColor', 'k', 'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7);
    end
    
    hold(ax, 'off');
    
    % --- 4. 图形美化与导出 ---
    xlabel(ax, options.XLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    ylabel(ax, options.YLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    title(ax, options.Title, 'FontSize', options.TitleFontSize, 'FontName', options.FontName);
    if ~isempty(options.LegendLabels), lgd = legend(ax, options.LegendLabels, 'Location', 'best'); set(lgd, 'FontSize', options.LegendFontSize, 'FontName', options.FontName, 'Box', 'on'); end
    set(ax, 'Box', 'on', 'LineWidth', options.AxisLineWidth, 'FontName', options.FontName, 'FontSize', options.AxisFontSize, 'TickDir', 'in', 'XMinorTick', 'on', 'YMinorTick', 'on', 'Layer', 'top');
    grid(ax, 'on'); ax.GridLineStyle = ':'; ax.GridAlpha = 0.4;
    if ~isempty(options.SavePath) && strlength(options.SavePath) > 0, try, exportgraphics(ax, options.SavePath, 'Resolution', options.Resolution); catch ME, warning(ME.identifier, '导出图形失败: %s\n尝试使用旧版 print 函数。', ME.message); print(fig_handle, options.SavePath, '-dpng', ['-r', num2str(options.Resolution)]); end, end
end