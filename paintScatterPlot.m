%% MATLAB 学术散点图生成框架
% 本脚本旨在将一个 m x n 矩阵绘制成符合学术期刊审美标准的散点图。
% 它包含了详细的注释和可配置的参数，方便用户根据自己的需求进行修改。

% --- 1. 初始化环境 ---
clc;            % 清空命令行窗口
clear;          % 清空工作区变量
close all;      % 关闭所有图形窗口

%% --- 2. 生成或加载您的数据 ---
% 在这里，您应该加载或定义您的 m x n 矩阵。
% 为了演示，我们创建两种常见的示例数据。

% --- 场景A: m x 2 矩阵 ---
% m 个数据点，第1列是x值，第2列是y值。
% data_A = randn(100, 2); % 100个点的x和y坐标

% --- 场景B: m x n 矩阵，包含多个数据组 ---
% 假设我们有3组数据，每组50个点。
% 矩阵的前两列是第一组的(x,y)，三四列是第二组的(x,y)，以此类推。
num_points = 50; % 每组的数据点数
num_groups = 3;  % 数据组的数量
data_B = zeros(num_points, 2 * num_groups);
for i = 1:num_groups
    % 为每组数据生成一些有区分度的随机数
    mean_val = i * 2;
    data_B(:, (2*i-1):(2*i)) = mean_val + randn(num_points, 2);
end

% --- 选择您要使用的数据 ---
% 将您的数据矩阵赋值给 'data' 变量
data = data_B; % 在此切换 data_A 或 data_B，或您自己的数据

%% --- 3. 绘图参数设置 ---
% 在这里统一设置图形的视觉元素，方便修改

% --- 标记和颜色 ---
marker_size = 8; % 标记点的大小
marker_styles = {'o', 's', '^', 'd'}; % 标记样式: o-圆圈, s-方块, ^-三角, d-菱形
% color_map = lines(num_groups); % 使用MATLAB内置的颜色方案
% 或者自定义颜色 (RGB值)，更推荐，因为更具可控性
color_map = [
    0, 0.4470, 0.7410;  % 蓝色
    0.8500, 0.3250, 0.0980;  % 橙色
    0.9290, 0.6940, 0.1250;  % 黄色
    % 可根据需要添加更多颜色
];

% --- 字体和线条 ---
font_name = 'Times New Roman'; % 推荐使用 Times New Roman 或 Arial
font_size_axis = 12;    % 坐标轴标签字号
font_size_legend = 10;  % 图例字号
font_size_title = 14;   % 标题字号
line_width_axis = 1.2;  % 坐标轴线宽

%% --- 4. 开始绘图 ---
% 创建一个新的图形窗口
figure('Color', 'w'); % 设置背景为白色

hold on; % 允许在同一张图上绘制多个数据集

% --- 循环绘制每个数据组 ---
% 此循环结构适用于场景B。如果您的数据是场景A，则不需要循环。
[~, n_cols] = size(data);
num_groups_in_data = n_cols / 2;

for i = 1:num_groups_in_data
    x_data = data(:, 2*i - 1);
    y_data = data(:, 2*i);
    
    scatter(x_data, y_data, marker_size, ...
        'Marker', marker_styles{i}, ...
        'MarkerFaceColor', color_map(i, :), ...
        'MarkerEdgeColor', 'k', ... % 标记点边缘颜色，'k'为黑色
        'LineWidth', 0.5);
end

hold off; % 结束在当前图上的绘制

%% --- 5. 图形美化与调整 ---
% 这是让图片符合学术标准最关键的一步

% --- 获取当前坐标轴句柄 ---
ax = gca;

% --- 设置坐标轴标签和标题 ---
xlabel('X-axis Label (Unit)', 'FontSize', font_size_axis, 'FontName', font_name, 'FontWeight', 'bold');
ylabel('Y-axis Label (Unit)', 'FontSize', font_size_axis, 'FontName', font_name, 'FontWeight', 'bold');
title('Title of the Figure', 'FontSize', font_size_title, 'FontName', font_name);

% --- 设置图例 ---
% 仅当有多个数据组时才需要图例
if num_groups_in_data > 1
    legend_labels = cell(1, num_groups_in_data);
    for i = 1:num_groups_in_data
        legend_labels{i} = ['Group ', num2str(i)];
    end
    lgd = legend(legend_labels, 'Location', 'northwest'); % 'best' 'northwest' 'southeast'
    set(lgd, 'FontSize', font_size_legend, 'FontName', font_name, 'Box', 'on'); % 设置图例字体和边框
end

% --- 调整坐标轴外观 ---
set(ax, ...
    'Box', 'on', ...                               % 显示完整的边框
    'LineWidth', line_width_axis, ...              % 设置坐标轴线宽
    'FontName', font_name, ...                     % 设置刻度字体
    'FontSize', font_size_axis, ...                % 设置刻度字号
    'TickDir', 'in', ...                           % 刻度线朝内
    'XMinorTick', 'on', ...                        % 显示X轴次刻度
    'YMinorTick', 'on', ...                        % 显示Y轴次刻度
    'Layer', 'top');                               % 将坐标轴层置于顶层，防止被数据覆盖

% --- 设置坐标轴范围 (可选) ---
% xlim([min_x, max_x]);
% ylim([min_y, max_y]);
% axis tight; % 或者让MATLAB自动选择紧凑的范围

% --- 添加网格 (可选) ---
grid on;
ax.GridLineStyle = ':'; % 设置网格线为虚线
ax.GridAlpha = 0.4;     % 设置网格线透明度

%% --- 6. 导出图形 ---
% 将最终的图形保存为高分辨率文件

% --- 设置文件名和分辨率 ---
output_filename = 'scatter_plot_academic';
resolution = 300; % DPI (Dots Per Inch), 300或600是期刊常用值

% --- 导出为PNG格式 (适用于大多数情况) ---
print(gcf, output_filename, '-dpng', ['-r', num2str(resolution)]);

% --- 导出为EPS格式 (矢量图，适用于LaTeX) ---
% print(gcf, output_filename, '-depsc');

% --- 使用 exportgraphics (推荐，功能更强大) ---
% exportgraphics(ax, [output_filename, '.png'], 'Resolution', resolution);
% exportgraphics(ax, [output_filename, '.eps'], 'ContentType', 'vector');


disp('学术散点图已生成并保存！');
