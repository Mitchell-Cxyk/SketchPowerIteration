function S = EstimateSpectrum(A,varargin)
    %This script is estimate the spectrum of matrix A. Also support sketch
    %parameter d input. 
    [m,n]=size(A);
    s=min(m,n);
    mn=max(m,n);
    d=2*s;% Set subspace embedding parameter d=2s. 
    if length(varargin)>=1
        d=varargin{1};
    end
    C=constructTestMatrix(d,mn,'sparsesign');
    if m<n
    A=A';
    end
    Z=full(C*double(A));%matlab only allow sparse mtimes double
    S=svd(Z,'econ','vector');
   
    S=S/sqrt(mn/min(size(Z)))*10;%The sparseSign matrix has sparse density 0.01. If use other density u, this should be sqrt(u)^-1.
end