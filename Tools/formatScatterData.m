function formatted_data = formatScatterData(x_column, y_matrix)
%formatScatterData 将共享的x列和多个y列矩阵格式化为绘图函数所需格式
%
%   语法:
%       formatted_data = formatScatterData(x_column, y_matrix)
%
%   说明:
%       本函数接收一个x数据列向量和一个包含多个y数据系列的矩阵，
%       然后将它们交错组合成一个新矩阵，格式为 [x, y1, x, y2, ...]。
%       这个格式是 createAcademicScatter 函数所要求的标准输入格式。
%
%   输入参数:
%       x_column - m x 1 的列向量，包含共享的 x 轴数据。
%       y_matrix - m x n 的矩阵，每一列代表一个独立的 y 数据系列。
%
%   输出参数:
%       formatted_data - m x (2*n) 的矩阵，数据已按 [x, y1, x, y2, ...] 的
%                        顺序排列好。
%
%   示例:
%       x = (1:10)';
%       y = [x.^2, 2*x+5];
%       data_for_plot = formatScatterData(x, y);
%
%   作者: Gemini
%   日期: 2025-08-29

% --- 1. 输入参数校验 ---
% 检查 x 和 y 的行数是否匹配
if size(x_column, 1) ~= size(y_matrix, 1)
    error('输入错误: x_column 和 y_matrix 的行数（数据点数量）必须相同。');
end

% 确保 x_column 是一个列向量
if ~iscolumn(x_column)
    if isrow(x_column)
        x_column = x_column'; % 如果是行向量，则转置为列向量
    else
        error('输入错误: x_column 必须是一个向量（行或列）。');
    end
end

% --- 2. 核心逻辑 (使用向量化操作) ---
[num_points, num_groups] = size(y_matrix);

% 预分配输出矩阵的内存
formatted_data = zeros(num_points, 2 * num_groups);

% 一次性将 x 数据放入所有奇数位置的列 (1, 3, 5, ...)
% 使用 repmat 复制 x 列，使其维度与目标位置匹配
formatted_data(:, 1:2:end) = repmat(x_column, 1, num_groups);

% 一次性将 y 矩阵的数据放入所有偶数位置的列 (2, 4, 6, ...)
formatted_data(:, 2:2:end) = y_matrix;

end