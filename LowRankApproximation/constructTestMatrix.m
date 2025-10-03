function S = constructTestMatrix(m,n,distribution,varargin)
% constructTestMatrix Generates different types of test matrices
%
% Inputs:
%   distribution - String specifying the distribution type:
%                 'gaussian', 'rademacher', 'countsketch', 'sparsegaussian'
%   m - Number of rows in the output matrix
%   n - Number of columns in the output matrix
%
% Output:
%   S - Generated test matrix of size m x n

distribution = lower(distribution);

switch distribution
    case 'gaussian'
        % Standard Gaussian distribution
        S = randn(m, n);
        
    case 'rademacher'
        % Rademacher distribution (±1 with equal probability)
        S = sign(rand(m, n) - 0.5);

    case 'countsketch'
        if m>=n
            S = zeros(m, n);
        for j = 1:m
            col_idx = randi(n);
            S(j,col_idx) = sign(rand - 0.5);
        end
        elseif m<n
            S = zeros(m, n);
        for j = 1:n
            row_idx = randi(m);
            S(row_idx, j) = sign(rand - 0.5);
        end
        end

        
    case 'countsketchcolumn'
        % CountSketch matrix: each column has exactly one ±1, rest zeros
        S = zeros(m, n);
        for j = 1:n
            row_idx = randi(m);
            S(row_idx, j) = sign(rand - 0.5);
        end
        
    case 'countsketchrow'
        % CountSketch matrix: each column has exactly one ±1, rest zeros
        S = zeros(m, n);
        for j = 1:m
            col_idx = randi(n);
            S(j,col_idx) = sign(rand - 0.5);
        end
        
    case 'sparserademacher'
        % Use MATLAB's sparse random function
        sparsity = 0.01;  % 10% non-zero entries
        if nargin>=1
            sparsity=varargin{1};
        end
        S = sign(sprandn(m, n, sparsity));  % Creates sparse random matrix directly
    case 'sparserademacher01'
    % Use MATLAB's sparse random function
    sparsity = 0.1;  % 10% non-zero entries
    S = sign(sprandn(m, n, sparsity));  % Creates sparse random matrix directly
    
    case 'sparsesign'
        S=rand_sign_sparse_shortside(m,n);
    case 'sparseiid'
        sparsity=0.01;
        if nargin>=4
            sparsity=varargin{1};
        end
        randmask=rand(m,n)<sparsity;
        S=randmask.*sign(randn(m,n));
    otherwise
        if contains(distribution,'sparserademacher')
            str=erase(distribution,'sparserademacher');
            if str(1) == '0'
            tail = str(2:end);
            num = str2double(['0.' tail]);
            else
                num = str2double(str);
            end
            sparsity=num;
            S = sign(sprandn(m, n, sparsity));
        else
        error('Unknown distribution type. Valid options are: Gaussian, Rademacher, CountSketch, CountsketchColumn, CountsketchRow, sparseRademacher.');
        end
        end

end
