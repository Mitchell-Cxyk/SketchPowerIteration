function varargout = alignVectors(varargin)
        % 功能：确保基准向量大部分元素为正，并以此对齐其他向量
        % 输入：varargin = {v1, v2, v3, ..., vN}（至少2个向量）
        % 输出：调整后的向量
        
        % 检查输入
        if nargin < 2
            error('至少需要输入2个向量');
        end
        
        % 第一步：调整基准向量（v1）
        v1 = varargin{1};
        
        % 计算正元素比例
        positive_ratio = mean(v1 >= 0);
        
        % 如果负元素占多数（比例<0.5），则翻转基准向量
        if positive_ratio < 0.5
            v1 = -v1;
            fprintf('注意：基准向量已被翻转以保持多数元素为正\n');
        end
        
        % 第二步：对齐其他向量
        varargout = cell(1, nargin);
        varargout{1} = v1;  % 存储调整后的基准向量
        
        for i = 2:nargin
            vi = varargin{i};
            % 使用点积判断是否需要翻转
            if dot(v1, vi) < 0
                varargout{i} = -vi;
            else
                varargout{i} = vi;
            end
        end
    end