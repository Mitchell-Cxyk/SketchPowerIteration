function [tmed, varargout] = timeit_step(fh, N)
    if nargin < 2 || isempty(N), N = 5; end
    % 预热
    fh();
    ts = zeros(N,1);
    for i = 1:N
        t0 = tic;
        if nargout > 1 && i == N
            [varargout{1:nargout-1}] = fh(); % 最后一次把结果带出来（含多个输出）
        else
            fh();
        end
        ts(i) = toc(t0);
    end
    tmed = median(ts);
end