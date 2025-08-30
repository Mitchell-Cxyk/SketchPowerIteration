errListRSVD=zeros(4,5);
errListRSVDSpec=zeros(4,5);
iter1=0;[m,n]=size(dataMatrix);r=5;
for T=80:30:170
    T
    iter1=iter1+1;
    for iter=1:5
    iter
    s=floor(T*n/(m+n));
Y=dataMatrix*randn(size(dataMatrix,2),s);
[QQ,~]=qr(double(Y),0);
BB=QQ'*dataMatrix;
[UU,SS,VV]=svd(BB,'econ');
UU=QQ*UU;
errListRSVD(iter1,iter)=norm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix,'fro')/normAbest-1;
errListRSVDSpec(iter1,iter)=estspecnorm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix)/S(6,6)-1;
    end
end