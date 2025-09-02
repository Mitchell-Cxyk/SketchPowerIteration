
m=1000;n=1000;decay='exp';decayRate=0.02;
A=GenerateData(m,n,decay,decayRate,10);
% A=imageMatrix20000;[m,n]=size(imageMatrix20000);
% A=dataMatrix;
% [m,n]=size(dataMatrix);
% S=diag(S);
T=170;
r=20;l=T;
% s=50;MentoCarloNum=100;d=110;
S=svd(A);
Phi=randn(n,T);Omega=randn(n,T);Psi=randn(T,m);
Z=A*Phi;Y=A*Omega;W=Psi*A;
[Q,~]=qr(Y(:,1:T/2),'econ');
SRSVD=svd(Q'*A,'econ');
s=TYUC17ParamenterGuide(n,T,r,decay,decayRate);
[Q,~]=qr(Y(:,1:floor(s)),'econ');
d=T-s;
STYUC=svd((Psi(1:d,:)*Q)\W(1:d,:),'econ');
s=ParameterGuide(n,T,r,decay,decayRate);
d=T-s;
[Q1,~]=qr(Z'*Y(:,1:s),'econ');[Q1,~]=qr(Z*Q1,'econ');
SSPI=svd((Psi(1:d,:)*Q1)\W(1:d,:),'econ');
gcf=paintFunc(@semilogy,1:r,[S(1:r),SSPI(1:r),STYUC(1:r),SRSVD(1:r)]',{'-',':','--','-.'},'DisplayName',{'exact','SPI q=1','TYUC17','RSVD'},'ColorOrder',[8,1,4,7]);
title([decay,':',num2str(decayRate)]);
% saveas(gcf,strcat("figure/ClimateSingularValue/SingularValueNIST_r",num2str(r),"_T",num2str(Tlist(iter)),".fig"));


