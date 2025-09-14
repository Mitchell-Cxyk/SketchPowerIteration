d=20;m=1000;n=100;
Phi=constructTestMatrix(m,n,'sparseRademacher');
[U,~]=qr(randn(m,d));
U=U';
S=svd(full(U*Phi),'econ');
% S=S(S>1e-10);
figure(1);
semilogy(S);

Phi=constructTestMatrix(m,n,'sparseRademacher01');
% [U,~]=qr(randn(m,d));
% U=U';
S1=svd(full(U*Phi),'econ');
% S=S(S>1e-10);
figure(2);
semilogy(S1);