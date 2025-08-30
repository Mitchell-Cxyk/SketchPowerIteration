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
    
    % --- New Parameters: Control Mean and Median Lines ---
    addParameter(p, 'ShowMeanLine', false, @islogical);
    addParameter(p, 'MeanLineColor', 'r');         % red
    addParameter(p, 'MeanLineWidth', 2, @isnumeric); 
    addParameter(p, 'MeanLineStyle', '--');        % dashed line
    addParameter(p, 'ShowMedianLine', false, @islogical);
    addParameter(p, 'MedianLineColor', [0 .5 0]);  % dark green
    addParameter(p, 'MedianLineWidth', 2, @isnumeric); 
    addParameter(p, 'MedianLineStyle', ':');       % dotted line

    parse(p, varargin{:});
    options = p.Results;
    
    fig_handle = figure('Color', 'w');
    ax = gca;
    hold(ax, 'on');
    
    % --- 2. Data Cleaning and Preparation ---
    all_x = data(:, 1:2:end); all_y = data(:, 2:2:end);
    all_x = all_x(:); all_y = all_y(:);
    is_valid = ~(isnan(all_x) | isinf(all_x) | isnan(all_y) | isinf(all_y));
    all_x_cleaned = all_x(is_valid);
    all_y_cleaned = all_y(is_valid);
    
    % --- 3. Plot Boundary/Shading (Original Logic Restored) ---
    if ~strcmpi(options.BoundaryType, 'none') && numel(all_x_cleaned) >= 3
        switch lower(options.BoundaryType)
            case 'shaded'
                min_x_val = min(all_x_cleaned);
                max_x_val = max(all_x_cleaned);
                bin_edges = linspace(min_x_val, max_x_val, options.NumBins + 1);
                bin_edges(end) = max_x_val; 
                [~, bin_indices] = histc(all_x_cleaned, bin_edges); % Using the original histc
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
                
                valid_bins = ~isnan(bin_centers_for_plot); 
                bin_centers_for_plot = bin_centers_for_plot(valid_bins);
                upper_boundary = upper_boundary(valid_bins);
                lower_boundary = lower_boundary(valid_bins);
                
                if numel(bin_centers_for_plot) < 2
                     warning('Not enough valid bins to draw shaded boundary.');
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
                        warning('Data points are collinear or fewer than 3 unique points; cannot compute concave hull. Reverting to convex hull.');
                        k = convhull(all_x_cleaned, all_y_cleaned);
                        plot(ax, all_x_cleaned(k), all_y_cleaned(k), 'Color', options.BoundaryColor, 'LineWidth', options.BoundaryWidth, 'LineStyle', '--');
                    else
                        shp = alphaShape(all_x_cleaned, all_y_cleaned);
                        shp.Alpha = shp.criticalAlpha('one-region');
                        plot(ax, shp, 'FaceColor', 'none', 'EdgeColor', options.BoundaryColor, 'LineWidth', options.BoundaryWidth);
                    end
                catch ME, warning(ME.identifier, 'An unknown error occurred while calculating the alpha shape boundary: %s', ME.message); end
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
        style_idx = mod(i-1, length(options.MarkerStyles)) + 1;
        color_idx = mod(i-1, size(options.ColorMap, 1)) + 1;
        scatter_handles(i) = scatter(ax, x_data, y_data, options.MarkerSize, 'filled', ...
            'Marker', options.MarkerStyles{style_idx}, ...
            'MarkerFaceColor', options.ColorMap(color_idx, :), ...
            'MarkerEdgeColor', 'k', 'LineWidth', 0.5, 'MarkerFaceAlpha', 0.7);
    end
    
    % --- 5. Plot Conditional Mean and Median Lines ---
    legend_handles = scatter_handles(isgraphics(scatter_handles));
    legend_entries = options.LegendLabels;
    
    if options.ShowMeanLine || options.ShowMedianLine
        unique_x = unique(all_x_cleaned);
        
        mean_y_values = NaN(size(unique_x));
        median_y_values = NaN(size(unique_x));
        
        for i = 1:length(unique_x)
            current_x = unique_x(i);
            y_at_current_x = all_y_cleaned(all_x_cleaned == current_x);
            
            if ~isempty(y_at_current_x)
                if options.ShowMeanLine
                    mean_y_values(i) = mean(y_at_current_x, 'omitnan');
                end
                if options.ShowMedianLine
                    median_y_values(i) = median(y_at_current_x, 'omitnan');
                end
            end
        end
        
        if options.ShowMeanLine
            valid_idx = ~isnan(mean_y_values);
            h_mean = plot(ax, unique_x(valid_idx), mean_y_values(valid_idx), ...
                'Color', options.MeanLineColor, 'LineWidth', options.MeanLineWidth, ...
                'LineStyle', options.MeanLineStyle, 'Marker', 'none'); 
            legend_handles(end+1) = h_mean;
            legend_entries{end+1} = 'Mean';
        end

        if options.ShowMedianLine
            valid_idx = ~isnan(median_y_values);
            h_median = plot(ax, unique_x(valid_idx), median_y_values(valid_idx), ...
                'Color', options.MedianLineColor, 'LineWidth', options.MedianLineWidth, ...
                'LineStyle', options.MedianLineStyle, 'Marker', 'none');
            legend_handles(end+1) = h_median;
            legend_entries{end+1} = 'Median';
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

    set(ax, 'Box', 'on', 'LineWidth', options.AxisLineWidth, 'FontName', options.FontName, 'FontSize', options.AxisFontSize, 'TickDir', 'in', 'XMinorTick', 'on', 'YMinorTick', 'on', 'Layer', 'top');
    grid(ax, 'on'); ax.GridLineStyle = ':'; ax.GridAlpha = 0.4;
    
    if ~isempty(options.SavePath) && strlength(options.SavePath) > 0
        try 
            exportgraphics(ax, options.SavePath, 'Resolution', options.Resolution);
        catch ME
            warning(ME.identifier, 'Failed to export graphics: %s\nAttempting to use the legacy print function.', ME.message); 
            print(fig_handle, options.SavePath, '-dpng', ['-r', num2str(options.Resolution)]); 
        end
    end
end