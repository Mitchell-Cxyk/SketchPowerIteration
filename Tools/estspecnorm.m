function s=estspecnorm(A,tol,maxlength)
    if nargin <=1
        tol = 1e-4;
    end
    if nargin <= 2
        maxlength = 650;
    end
     [~,S11,~]=svdsketch(A,tol,'MaxSubspaceDimension',maxlength);
     s=S11(1);
end