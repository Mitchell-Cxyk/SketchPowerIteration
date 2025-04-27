function decayRates = calculateDecayRates(x)
    % 确保输入是列向量
    x = x(:);
    
    % 计算衰减率，即下一个数除以上一个数
    decayRates = x(2:end) ./ x(1:end-1);
end