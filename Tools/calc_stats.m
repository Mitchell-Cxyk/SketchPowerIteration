function [mu, var_vec, cv] = calc_stats(X)
    % X: m x n 矩阵
    % 输出:
    %   mu      - 1 x n 均值向量
    %   var_vec - 1 x n 方差向量
    %   cv      - 1 x n 变异系数向量

    % 按列计算均值 (每列是一个样本组)
    mu = mean(X, 1);       

    % 按列计算方差
    var_vec = var(X, 0, 1);   % 第二个参数0表示无偏估计 (除以 m-1)

    % 按列计算标准差
    sigma = sqrt(var_vec);

    % 计算变异系数 CV
    cv = sigma ./ mu;
end
