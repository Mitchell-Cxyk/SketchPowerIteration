% 仍以 X (文档×词, TF-IDF + L2) 为起点
% 列白化：使每列零均值、单位方差（在稀疏上做，先转稀疏均值）
colMean = full(mean(X,1));
Xc = X - repmat(sparse(colMean), size(X,1), 1);

colStd = sqrt(full(var(Xc,0,1))) + 1e-6;
Xw = bsxfun(@rdivide, Xc, colStd);

[U,S,V] = svds(Xw, 300);
s = diag(S);
figure; loglog(s, '-o'); grid on
title('SVD after column whitening');
