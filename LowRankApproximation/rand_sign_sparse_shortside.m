function A = rand_sign_sparse_shortside(n, m, k)
% 生成 n×m 稀疏随机符号矩阵（元素为 ±1）。
% 沿较短的维度约束稀疏度：
%   - 若 n <= m：每列恰有 min(k, n) 个非零（满足“最多 k 个”）
%   - 若 n >  m：每行恰有 min(k, m) 个非零（满足“最多 k 个”）
%
% 用法：
%   A = rand_sign_sparse_shortside(n, m)      % 默认 k=8
%   A = rand_sign_sparse_shortside(n, m, k)   % 自定义 k
%
% 说明：如果你确实希望“最多”而不是“恰好”，可以把下面的 t 固定为
%      randi([0, min(k,dimlen)]) 来得到列/行内可变的非零个数。

    if nargin < 3, k = 8; end
    assert(n >= 1 && m >= 1, 'n 和 m 必须为正整数。');

    if n <= m
        % 约束每列
        t = min(k, n);                       % 每列非零个数
        nnz_total = m * t;
        I = zeros(nnz_total, 1);             % 行索引
        J = zeros(nnz_total, 1);             % 列索引
        V = zeros(nnz_total, 1);             % 值（±1）
        idx = 1;
        for j = 1:m
            rows = randperm(n, t);           % 本列选择的行
            sgn  = randi([0,1], t, 1) * 2 - 1;
            I(idx:idx+t-1) = rows(:);
            J(idx:idx+t-1) = j;
            V(idx:idx+t-1) = sgn;
            idx = idx + t;
        end
    else
        % 约束每行
        t = min(k, m);                       % 每行非零个数
        nnz_total = n * t;
        I = zeros(nnz_total, 1);             % 行索引
        J = zeros(nnz_total, 1);             % 列索引
        V = zeros(nnz_total, 1);             % 值（±1）
        idx = 1;
        for i = 1:n
            cols = randperm(m, t);           % 本行选择的列
            sgn  = randi([0,1], t, 1) * 2 - 1;
            I(idx:idx+t-1) = i;
            J(idx:idx+t-1) = cols(:);
            V(idx:idx+t-1) = sgn;
            idx = idx + t;
        end
    end

    A = sparse(I, J, V, n, m);
end
