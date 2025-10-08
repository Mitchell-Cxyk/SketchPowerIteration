% 参数设置
m = 20;          % 矩阵A的行数
n = 2000;        % 矩阵A的列数
k = 150;         % 投影矩阵S的列数
density = 0.01;  % 稀疏度
epsilon = 0.2;   % 误差容忍度
num_trials = 1000; % 实验次数
success_count = 0;

% 生成固定秩的矩阵A（秩为20）
r = 20;
A = randn(m, r) * randn(r, n); % 生成秩为r的矩阵

% 预计算A的奇异值
[U, S_A, V] = svd(A, 'econ');
s_A = diag(S_A);

for i = 1:num_trials
    % 生成稀疏投影矩阵S（±1，均匀分布）
    S = sprand(n, k, density); % 创建稀疏矩阵框架
    [rows, cols, ~] = find(S);
    vals = randi([0,1], numel(rows), 1)*2 -1; % 生成±1
    S = sparse(rows, cols, vals, n, k);
    
    % 计算SA并保留前r个奇异值
    SA = S' * A';
    [~, S_SA, ~] = svds(SA, r);
    s_SA = diag(S_SA);
    
    % 检查奇异值比例
    s_SA=s_SA./mean(s_SA,"all")*mean(s_A,"all");
    ratios = s_SA ./ s_A(1:r);
    if all(ratios >= (1 - epsilon)) && all(ratios <= (1 + epsilon))
        success_count = success_count + 1;
    end
end

% 输出结果
fprintf('Successful Rate: %.2f%%\n', (success_count/num_trials)*100);

% 绘制最后一次实验的奇异值对比
figure;
plot(1:r, s_A(1:r), 'bo-', 1:r, s_SA, 'rx--');
legend('Original Singular Values', 'Sketched Singular Values');
% xlabel('Singular Values');
ylabel('Singular Values');
title(sprintf('ε=%.1f  sparisty=%.3f success rate=%.1f%%', epsilon, density, (success_count/num_trials)*100));