m=1000;n=1000;
decay='poly';
decayRate=0.5;
A=GenerateData(m,n,decay,decayRate,10);
r=10;l=n;s=20;MentoCarloNum=50;d=100;
Phi=randn(n,l);Z=A;Psi=randn(d,m);
% Psi=eye(m);
W=Psi*A;
qlist=[1:10,12:5:40];
errF=zeros(MentoCarloNum,numel(qlist));
errS=zeros(MentoCarloNum,numel(qlist));
errF1=zeros(MentoCarloNum,numel(qlist));
errS1=zeros(MentoCarloNum,numel(qlist));
for iter=1:MentoCarloNum
    iter
    % Phi=randn(n,l);Z=A*Phi;
    Omega=randn(n,s);
    Y=A*Omega;
    Y=Z*randn(l,s);
    Yc=Y;
    for iterq=1:numel(qlist)
        Y=Yc;
        q=qlist(iterq);
        for iter1=1:q
            Y1=Z'*Y;
            [Y1,~]=qr(Y1,0);
            Y=Z*Y1;
        end
        [Q,~]=qr(Y,0);
        B=(Psi*Q)\W;
        [U,S,V]=svd(B,'econ');
        U=U(:,1:r);S=S(1:r,1:r);V=V(:,1:r);U=Q*U;
        B1=Q'*A;
        [U1,S1,V1]=tsvd(B1,r);U1=Q*U1;
        errF(iter,iterq)=norm(A-U*S*V','fro');
        errS(iter,iterq)=norm(A-U*S*V');
         errF1(iter,iterq)=norm(A-U1*S1*V1','fro');
        errS1(iter,iterq)=norm(A-U1*S1*V1');
    end
end
[UU,SS,VV]=tsvd(A,r);
normAbest=norm(A-UU*SS*VV','fro');
fileName=['testq_',decay,'_',num2str(decayRate),'FixedPhiPsiStandard.mat'];
save(fileName,'errF','errS','errF1','errS1',"normAbest",'A');
% [UU,SS,VV]=tsvd(A,r);
% normAbest=norm(A-UU*SS*VV','fro');
%%
relativeErrF=errF./normAbest-1;
data=formatScatterData(qlist',relativeErrF');
createAcademicScatter(data,'BoundaryType','shaded','ShowMeanLine',true,'YScale','log','XLabel','Iteration Number','YLabel','Relative Frobenius Error');
% data1=formatScatterData(qlist',errF1');
% createAcademicScatter(data1,'BoundaryType','shaded','ShowMeanLine',true,'YScale','log','XLabel','Iteration Number','YLabel','Relative Frobenius Error');
normA=svd(A);normA=normA(r+1);
relativeErrS=errS./normA-1;
data=formatScatterData(qlist',relativeErrS');
createAcademicScatter(data,'BoundaryType','shaded','ShowMeanLine',true,'YScale','log','XLabel','Iteration Number','YLabel','RelativeSpectral Error');

