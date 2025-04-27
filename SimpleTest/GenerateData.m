function [A,S]= GenerateData(m, n, decayType, decayRate, startIdx)
% GenerateData Generate test matrix with specified singular value decay pattern
%
% Inputs:
%   m          - Number of rows
%   n          - Number of columns
%   decayType  - Type of singular value decay:
%                'lowrank' - Low rank plus noise
%                'poly'    - Polynomial decay
%                'exp'     - Exponential decay
%   decayRate  - Rate of decay (positive number)
%   startIdx   - Index to start decay from
%
% Output:
%   A          - Generated matrix of size m x n

% Generate random orthogonal matrices
flag=0;
if m<n
    k=n;n=m;m=k;flag=1;
end
startIdx=startIdx+1;
S=computeS(m, n, decayType, decayRate, startIdx);
mn=min(m,n);
[U, ~] = qr(randn(m, mn), 0);
[V, ~] = qr(randn(mn, n), 0);
% Construct matrix
A = U * S * V';
if nargout>1
if strcmpi(decayType,'lowrank')
    S=svd(S);
else
S = diag(S);
end
end
if flag==1
    A=A';
end
end

function S=computeS(m, n, decayType, decayRate, startIdx)
mn=min(m,n);
% Initialize singular values
s = ones(mn, 1);

% Apply decay pattern
switch lower(decayType)
    case 'lowrank'
        % Low rank plus noise
        s(startIdx:end) = 0;
        G=randn(mn,mn);
        S=diag(s)+decayRate/mn*G*G';

    case 'poly'
        % Polynomial decay: s_i = i^(-decayRate)
        idx = startIdx:length(s);
        s(idx) = (idx').^(-decayRate);
        S=diag(s);
        
    case 'exp'
        % Exponential decay: s_i = exp(-decayRate * i)
        idx = startIdx:length(s);
        s(idx) = 10.^(-decayRate * (idx-startIdx+1));
        S=diag(s);  
        
    otherwise
        error('Unknown decay type. Valid options are: lowrank, poly, exp');
end
end