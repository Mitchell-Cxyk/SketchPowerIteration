d=20;m=1000;n=80;
% Phi=constructTestMatrix(m,n,'sparseRademacher',0.02);
[U,~]=qr(randn(m,d),0);
U=U';
% U=eye(d);
% U=[U,zeros(d,m-d)];
% S=svd(full(U*Phi),'econ');
% % S=S(S>1e-10);
% figure(1);
% semilogy(S);
MentoCarloNum=10000;
kappastore=zeros(2,MentoCarloNum);
sparsity=0.05;
for iter=1:MentoCarloNum
Phi=constructTestMatrix(m,n,'sparseRademacher',sparsity);
% [U,~]=qr(randn(m,d));
% U=U';
S1=svd(full(U*Phi),'econ');
% S=S(S>1e-10);
% figure(2);
% semilogy(S1);
kappastore(1,iter)=S1(1)/S1(end);

% Phi=constructTestMatrix(m,n,'Gaussian');
% % [U,~]=qr(randn(m,d));
% % U=U';
% S2=svd(full(U*Phi),'econ');
% % S=S(S>1e-10);
% figure(3);
% semilogy(S2);
% 
% Phi=constructTestMatrix(m,n,'sparsesign');
% % [U,~]=qr(randn(m,d));
% % U=U';
% S3=svd(full(U*Phi),'econ');
% % S=S(S>1e-10);
% figure(4);
% semilogy(S3);
% 
% Phi=constructTestMatrix(m,n,'sparsesign');
% % [U,~]=qr(randn(m,d));
% % U=U';
% S3=svd(full(U*Phi),'econ');
% % S=S(S>1e-10);
% figure(4);
% semilogy(S3);

Phi=constructTestMatrix(m,n,'sparseiid',sparsity);
% U=U';
S4=svd(full(U*Phi),'econ');
% S=S(S>1e-10);
% figure(5);
% semilogy(S4);
kappastore(2,iter)=S4(1)/S4(end);
end
kappa=mean(kappastore,2);
