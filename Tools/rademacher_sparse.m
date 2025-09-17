function S = rademacher_sparse(m, n, k, rngSeed)
% 生成 m×n 的随机稀疏 Rademacher 矩阵，恰好 k 个非零，位置均匀随机。
% 非零元素取值为 +1 或 -1，概率各 1/2。
% 可选 rngSeed 用于复现结果（例如 42）。

    if nargin == 4 && ~isempty(rngSeed)
        rng(rngSeed);
    end
    assert(k <= m*n, 'k 不能超过 m*n');
    k=floor(k);

    % 1) 随机选 k 个唯一线性索引（不会重复）
    idx = randperm(m*n, k);

    % 2) 转为 (i, j) 下标
    [ii, jj] = ind2sub([m, n], idx);

    % 3) 生成 ±1 值（Rademacher）
    v = 2*randi([0,1], k, 1) - 1;

    % 4) 构造稀疏矩阵（一次成型，最快）
    S = sparse(ii, jj, v, m, n);
end
