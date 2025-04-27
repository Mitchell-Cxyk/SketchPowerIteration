function C=mixedPrecisionMTIMES(A,B,varargin)
% This function is to simulate the mixed-precision matrix multiplication in
% the computations of the sketches Z'*Y or Z*Y1, where Y1 size l*s. 
% Default parameter corresponds to mtimes(d*d=d).
% If having one parameter, it must be 'ss' or 'dd' or 'hh' or 'hs' or 'sd'. 
% The first place is input class, the second place is compute class. 
% If having two parameter, tne second one is output form.
% The practical implement is using the "Block FMA" to compute
% C_{i,j}=C_{i,j}+A_{i,l}B{l,j} with low precision A and B and output at
% high precision C_{i,j} and convert to low-precision.It is applicable to NVIDIA Volta 
% and Turing tensor cores with b = 4 (Block number), ulow = u16 and uhigh =
% u32. More detailed information see in:
% Higham, Nicholas J., 和Theo Mary. 《Mixed Precision Algorithms in Numerical Linear Algebra》.
% Acta Numerica 31 (May 2022): 347–414. https://doi.org/10.1017/S0962492922000022.

flag='dd';outputform='d';
if numel(varargin)>=1
    flag=varargin{1}; outputform=flag(1);
end
if numel(varargin)>=2
    outputform=varargin{2};
end
    if strcmp(flag,'ss') || strcmp(flag,'hh')|| strcmp(flag,'dd') 
        % if the output do not need high precision result, use this.
        C=A*B;
    elseif strcmp(flag,'hs')
        %This feature is supported by NVIDIA GPU (after Volta) and orthers
        %to improve AI computing.
        %Due to matlab do not supply mix-precision multiply, we should
        %transfer them to single, then chop to half after computing.
         C=single(A)*single(B);
    elseif strcmp(flag,'sd')
        %Due to matlab do not supply mix-precision multiply, we should
        %transfer them to double, then chop to single after computing.

        % C=FMA_matmul(A,B); 
        C=double(A)*double(B);  % this is to simulate C=FMA_matmul(A,B)   

        % The above is to simulate the FMA computing, which will be called 
        % when the data matrix exhibits a very fast spectrum decay. Its
        % purpose is to computing C=A*B while avoiding loss of precision when both A and B have
        % lower-precision, without converting A and B to double to take
        % extra memory. 
        % Due to matlab's loop is very slow, one can use
        % C=double(A)*double(B) to simulate C=FMA_matmul(A,B) in tests to
        % speedup. In fact, C=FMA_matmul(A,B) almost achieves the same accuracy of
        % directly calling C=double(A)*double(B), but with very little
        % memory consuming. Use 
        % ../test/testFMASimulation.m to see this.

        
    else
        error("Not supported input! Must be ss, hh, dd, sd, hs.");
    end
    %Select output form
    if strcmp(outputform,'h')
        C=half(C);
    elseif strcmp(outputform,'s')
        C=single(C);
    elseif strcmp(outputform,'d')
        C=double(C);
    else
        error('outputform must be s or d or h');
    end
end
function C = FMA_matmul(A, B)
    % 将输入矩阵转换为单精度
    A_single = single(A);
    B_single = single(B);
    
    % 获取矩阵尺寸
    [m, n] = size(A_single);
    [n, p] = size(B_single);
    
    % 初始化单精度结果矩阵
    C = zeros(m, p, 'single');
    
    % 进行矩阵乘法
    for i = 1:m
        for j = 1:p
            sum_single = 0; % 单精度累加器
            % sum_single=single(0);
            for k = 1:n
                % 用双精度计算乘法以保留完整精度
                prod_double = double(A_single(i,k)) * double(B_single(k,j));
                % 将双精度乘法结果与单精度累加器相加，
                sum_single = sum_single + prod_double;
            end
            % C(i,j) = single(sum_single);
        end
    end
end
