function fig_handle = createAcademicScatter(data, varargin) 
    % --- 1. Parse Input Arguments using inputParser ---
    p = inputParser;
    
    % --- Default Settings ---
    defaultBoundaryType = 'none';
    validBoundaryTypes = {'none', 'convex', 'concave', 'shaded'};
    defaultNumBins = 20;
    defaultShadedColor = [0.5, 0.5, 0.5];
    defaultShadedAlpha = 0.2;
    defaultTitle = "Title of the Figure";
    defaultXLabel = "X-axis Label (Unit)";
    defaultYLabel = "Y-axis Label (Unit)";
    defaultLegendLabels = {};
    defaultMarkerStyles = {'o'};
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
    defaultYScale = 'linear';    % New: 'linear' or 'log'
    validYScales = {'linear','log'};

    % --- Add Parameter Parsing Rules ---
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
    addParameter(p, 'YScale', defaultYScale, @(x) any(validatestring(x, validYScales)));
    % New: Control Mean and Median Lines
    addParameter(p, 'ShowMeanLine', false, @islogical);
    addParameter(p, 'MeanLineColor', 'r');
    addParameter(p, 'MeanLineWidth', 2, @isnumeric);
    addParameter(p, 'MeanLineStyle', '--');
    addParameter(p, 'ShowMedianLine', false, @islogical);
    addParameter(p, 'MedianLineColor', [0 .5 0]);
    addParameter(p, 'MedianLineWidth', 2, @isnumeric);
    addParameter(p, 'MedianLineStyle', ':');

    parse(p, varargin{:});
    options = p.Results;

    fig_handle = figure('Color', 'w');
    ax = gca;
    hold(ax, 'on');
    set(ax, 'YScale', options.YScale);    % Apply y-axis scale

    % --- 2. Data Cleaning and Preparation ---
    all_x = data(:, 1:2:end); all_y = data(:, 2:2:end);
    all_x = all_x(:); all_y = all_y(:);
    is_valid = ~(isnan(all_x) | isinf(all_x) | isnan(all_y) | isinf(all_y));
    all_x_cleaned = all_x(is_valid);
    all_y_cleaned = all_y(is_valid);

    % --- 3. Plot Boundary/Shading ---
    if ~strcmpi(options.BoundaryType, 'none') && numel(all_x_cleaned) >= 3
        switch lower(options.BoundaryType)
            case 'shaded'
                % 使用 discretize 绘制带阴影的边界
                min_x_val = min(all_x_cleaned);
                max_x_val = max(all_x_cleaned);
                bin_edges = linspace(min_x_val, max_x_val, options.NumBins + 1);
                bin_indices = discretize(all_x_cleaned, bin_edges);
                upper_boundary = NaN(1, options.NumBins);
                lower_boundary = NaN(1, options.NumBins);
                for bin_i = 1:options.NumBins
                    idx = (bin_indices == bin_i);
                    if any(idx)
                        yk = all_y_cleaned(idx);
                        upper_boundary(bin_i) = max(yk);
                        lower_boundary(bin_i) = min(yk);
                    end
                end
                valid_bins = ~isnan(upper_boundary) & ~isnan(lower_boundary);
                if ~any(valid_bins)
                    warning('Not enough valid bins to draw shaded boundary.');
                else
                    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
                    x_core = bin_centers(valid_bins);
                    yU_core = upper_boundary(valid_bins);
                    yL_core = lower_boundary(valid_bins);
                    first_idx = find(valid_bins, 1, 'first');
                    last_idx  = find(valid_bins,  1, 'last');
                    left_edge  = bin_edges(first_idx);
                    right_edge = bin_edges(last_idx + 1);
                    x_line = [left_edge, x_core, right_edge];
                    yU_line = [upper_boundary(first_idx), yU_core, upper_boundary(last_idx)];
                    yL_line = [lower_boundary(first_idx), yL_core, lower_boundary(last_idx)];
                    fill_x = [x_line, fliplr(x_line)];
                    fill_y = [yU_line, fliplr(yL_line)];
                    fill(ax, fill_x, fill_y, options.ShadedColor, 'FaceAlpha', options.ShadedAlpha, 'EdgeColor', 'none');
                    plot(ax, x_line, yU_line, 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                    plot(ax, x_line, yL_line, 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                end
            case 'convex'
                k = convhull(all_x_cleaned, all_y_cleaned);
                plot(ax, all_x_cleaned(k), all_y_cleaned(k), 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
            case 'concave'
                try
                    unique_pts = unique([all_x_cleaned, all_y_cleaned], 'rows');
                    if size(unique_pts,1) < 3 || rank(bsxfun(@minus, unique_pts, mean(unique_pts))) < 2
                        warning('Insufficient points for concave hull, using convex hull.');
                        k = convhull(all_x_cleaned, all_y_cleaned);
                        plot(ax, all_x_cleaned(k), all_y_cleaned(k), 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth, 'LineStyle', '--');
                    else
                        shp = alphaShape(all_x_cleaned, all_y_cleaned);
                        shp.Alpha = shp.criticalAlpha('one-region');
                        plot(ax, shp, 'FaceColor', 'none', 'EdgeColor', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                    end
                catch ME
                    warning(ME.identifier, 'Error computing concave hull: %s', ME.message);
                end
        end
    elseif ~strcmpi(options.BoundaryType, 'none')
        warning('Fewer than 3 valid data points; cannot compute boundary.');
    end

    % --- 4. Plot Scatter Points ---
    [~, n_cols] = size(data);
    num_groups_in_data = n_cols / 2;
    scatter_handles = gobjects(1, num_groups_in_data);
    for i = 1:num_groups_in_data
        x_data = data(:, 2*i - 1);
        y_data = data(:, 2*i);
        style_idx = mod(i-1, numel(options.MarkerStyles)) + 1;
        color_idx = mod(i-1, size(options.ColorMap,1)) + 1;
        scatter_handles(i) = scatter(ax, x_data, y_data, options.MarkerSize, 'filled', ...
            'Marker', options.MarkerStyles{style_idx}, ...
            'MarkerFaceColor', options.ColorMap(color_idx,:), ...
            'MarkerEdgeColor', 'k', 'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7);
    end

    % --- 5. Plot Conditional Mean and Median Lines ---
    if ~isempty(options.LegendLabels)
        legend_handles = scatter_handles(isgraphics(scatter_handles));
        legend_entries = options.LegendLabels;
    else
        legend_handles = gobjects(0);
        legend_entries = {};
    end
    if options.ShowMeanLine || options.ShowMedianLine
        ux = unique(all_x_cleaned);
        my = NaN(size(ux));
        md = NaN(size(ux));
        for ii = 1:numel(ux)
            xv = ux(ii);
            yv = all_y_cleaned(all_x_cleaned==xv);
            if ~isempty(yv)
                if options.ShowMeanLine, my(ii)=mean(yv,'omitnan'); end
                if options.ShowMedianLine, md(ii)=median(yv,'omitnan'); end
            end
        end
        if options.ShowMeanLine
            im = ~isnan(my);
            h_mean = plot(ax, ux(im), my(im), 'Color', options.MeanLineColor, 'LineWidth', options.MeanLineWidth, 'LineStyle', options.MeanLineStyle);
            legend_handles(end+1)=h_mean; legend_entries{end+1}='Mean';
        end
        if options.ShowMedianLine
            id = ~isnan(md);
            h_med = plot(ax, ux(id), md(id), 'Color', options.MedianLineColor, 'LineWidth', options.MedianLineWidth, 'LineStyle', options.MedianLineStyle);
            legend_handles(end+1)=h_med; legend_entries{end+1}='Median';
        end
    end
    hold(ax, 'off');

    % --- 6. Finalize and Export Figure ---
    xlabel(ax, options.XLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    ylabel(ax, options.YLabel, 'FontSize', options.AxisFontSize, 'FontName', options.FontName, 'FontWeight', 'bold');
    title(ax, options.Title, 'FontSize', options.TitleFontSize, 'FontName', options.FontName);
    
    if ~isempty(legend_entries)
        lgd = legend(ax, legend_handles, legend_entries, 'Location', 'best');
        set(lgd, 'FontSize', options.LegendFontSize, 'FontName', options.FontName, 'Box', 'on');
    end
    set(ax, 'Box','on','LineWidth',options.AxisLineWidth,'FontName',options.FontName,'FontSize',options.AxisFontSize,'TickDir','in','XMinorTick','on','YMinorTick','on','Layer','top');
    grid(ax, 'on'); ax.GridLineStyle = ':'; ax.GridAlpha = 0.4;
    if ~isempty(options.SavePath)
        try
            exportgraphics(ax, options.SavePath, 'Resolution', options.Resolution);
        catch ME
            warning(ME.identifier,'Failed to export: %s',ME.message);
            print(fig_handle, options.SavePath,'-dpng',['-r',num2str(options.Resolution)]);
        end
    end
end
