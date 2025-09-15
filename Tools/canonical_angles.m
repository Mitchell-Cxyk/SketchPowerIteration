function [angles, sines, cosines] = canonical_angles(U1, U2, r)
% 计算两个子空间的前 r 个 canonical angles 及其 sin, cos 值
%
% 输入:
%   U1 : n x p1 列正交矩阵
%   U2 : n x p2 列正交矩阵
%   r  : 想要的角个数
%
% 输出:
%   angles  : 1 x r 向量, canonical angles (弧度)
%   sines   : 1 x r 向量, sin(theta)
%   cosines : 1 x r 向量, cos(theta)

    % 交叉矩阵
    M = U1' * U2;
    % 奇异值分解
    [~, S, ~] = svd(M, 'econ');
    s = diag(S);

    % 修正数值误差，保证落在 [0,1]
    s = min(max(s, 0), 1);

    % 默认 r = min(size(U1,2), size(U2,2))
    if nargin < 3 || isempty(r)
        r = min(size(U1,2), size(U2,2));
    else
        r = min(r, length(s));
    end

    cosines = s(1:r);
    angles  = acos(cosines);
    sines   = sin(angles);
end
