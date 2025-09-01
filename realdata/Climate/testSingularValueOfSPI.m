changeCurrentFolderToScriptFolder();
r=10;
Tlist=[170];iterMento=1;
for iter=1:numel(Tlist)
m=1000;n=1000;
% A=GenerateData(m,n,'exp',0.01,5);
% A=imageMatrix20000;[m,n]=size(imageMatrix20000);
A=dataMatrix;[m,n]=size(dataMatrix);
% S=diag(S);
T=Tlist(iter);
r=10;l=T;
% s=50;MentoCarloNum=100;d=110;
% S=svd(A);
Phi=randn(n,T);Omega=randn(n,T);Psi=randn(T,m);
Z=A*Phi;Y=A*Omega;W=Psi*A;
[Q,~]=qr(Y(:,1:T/2),'econ');
SRSVD=svd(Q'*A,'econ');
[Q,~]=qr(Y(:,1:floor(T/3)),'econ');
STYUC=svd((Psi*Q)\W,'econ');
s=ParameterGuide(n,T,r,'poly',0.6);
[Q1,~]=qr(Z'*Y(:,1:s),'econ');[Q1,~]=qr(Z*Q1,'econ');
SSPI=svd((Psi*Q1)\W,'econ');
figure;
paintFunc(@semilogy,1:r,[S(1:r),SSPI(1:r),STYUC(1:r),SRSVD(1:r)]',{'-',':','--','-.'},'DisplayName',{'exact','SPI q=1','TYUC17','RSVD'},'ColorOrder',[8,1,4,7]);
% saveas(gcf,strcat("figure/ClimateSingularValue/SingularValueNIST_r",num2str(r),"_T",num2str(Tlist(iter)),".fig"));
end

