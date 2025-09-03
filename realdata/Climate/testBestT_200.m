
r=5; T=140; m=10512; n=28144;decay='poly';decayRate=0.68;MenteCarloNum=10;
errList=zeros(4,290);
errListSpec=zeros(4,290);
% dataMatrix=dataMatrix';
for T=190
for s=10:T
s
% s=floor(ParameterGuide(n,T,r,decay,decayRate,m/n));
% s=31;
l=floor(n*T/m);d=(n*T-m*s)/n;d=floor(d);
if l<=s || d<=s
    disp('continue..');
    continue;
end
% r=20; s=50;l=100;d=100;
% [U,S,V]=svds(dataMatrix,100);
% errList=[];
% for s=r:T/2-1
% d=T-s;
lowrankSketchbackup=Sketch('A',dataMatrix,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',0,'Y_in_C',0);
LowRankApprox=LowRankApproxmation(lowrankSketchbackup);
relativeErrorSPI=norm(dataMatrix-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V','fro');
errList(1,s)=relativeErrorSPI;
errListSpec(1,s)=estspecnorm(dataMatrix-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V')/S(6,6)-1;
lowrankSketchbackup.iterationNum=2;
LowRankApprox2=LowRankApproxmation(lowrankSketchbackup);
relativeErrorSPI=norm(dataMatrix-LowRankApprox2.U*LowRankApprox2.S*LowRankApprox2.V','fro');
errList(3,s)=relativeErrorSPI;
errListSpec(3,s)=estspecnorm(dataMatrix-LowRankApprox2.U*LowRankApprox2.S*LowRankApprox2.V')/S(6,6)-1;
lowrankSketchbackup.iterationNum=3;
LowRankApprox3=LowRankApproxmation(lowrankSketchbackup);
relativeErrorSPI=norm(dataMatrix-LowRankApprox3.U*LowRankApprox3.S*LowRankApprox3.V','fro');
errList(4,s)=relativeErrorSPI;
errListSpec(4,s)=estspecnorm(dataMatrix-LowRankApprox3.U*LowRankApprox3.S*LowRankApprox3.V')/S(6,6)-1;
LowRankApprox=LowRankApproxmation(lowrankSketchbackup);

lowrankSketchbackup.iterationNum=0;
lowrankSketchbackup.mixedPrecision=0;
LowRankApprox1=LowRankApproxmation(lowrankSketchbackup);
errList(2,s)=norm(dataMatrix-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro');
errListSpec(2,s)=estspecnorm(dataMatrix-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V')/S(6,6)-1;
filename=['dataBestT/BestT',num2str(T),'_',num2str(s),'.mat'];
save(filename,'LowRankApprox','LowRankApprox1','LowRankApprox2','LowRankApprox3');
% end
% s=floor(T/3);
% % s=T/2-1;
% % T=T/2;
% % s=max(r+2,floor((T-1)*((sqrt(r*(T-r-2)*(1-2/(T-1)))-(r-1))/(T-2*r-1))));
% % T=T*2;
% % s=31;
% d=n*T-m*s;d=floor(d/n);
% lowrankSketchbackup1=Sketch('A',dataMatrix,'r',r,'s',s,'l',l,'d',d,'distribution','sparseRademacher','iterationNum',0,'mixedPrecision',0,'fixedW',0,'Y_in_C',0);
% LowRankApprox1=LowRankApproxmation(lowrankSketchbackup1);

% norm(lowrankSketchbackup.A-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro');
end
% s=floor(T*n/(m+n));
% Y=dataMatrix*randn(size(dataMatrix,2),s);
% [QQ,~]=qr(double(Y),0);
% BB=QQ'*dataMatrix;
% [UU,SS,VV]=svd(BB,'econ');
% UU=QQ*UU;
% relativeErrorRSVD=norm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix,'fro')/normAbest-1;
% relativeErrorRSVDSpec=estspecnorm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix)/S(6,6)-1;
end
save(['dataBestT/TwithQ',num2str(T),'_',num2str(s),'.mat'],'errList',"errListSpec");
%%
errList(errList==0)=Inf;
[minSPI,count]=min(errList(1,:));
minSPI=minSPI/normAbest-1;
errListSpec(errListSpec==0)=Inf;
[minTYUC17,count2]=min(errList(2,:));
minTYUC17=minTYUC17/normAbest-1;

[minSPISpec,countSpec]=min(errListSpec(1,:));
[minTYUC17Spec,count2Spec]=min(errListSpec(2,:));


load(['dataBestT/BestT',num2str(T),'_',num2str(count),'.mat']);
leftSPI=norm(dataMatrix-LowRankApprox.U*(LowRankApprox.U'*dataMatrix),'fro')/normAbest-1;
rightSPI=norm(dataMatrix-(dataMatrix*LowRankApprox.V)*LowRankApprox.V','fro')/normAbest-1;
load(['dataBestT/BestT',num2str(T),'_',num2str(countSpec),'.mat']);
leftSPISpec=estspecnorm(dataMatrix-LowRankApprox.U*(LowRankApprox.U'*dataMatrix))/S(6,6)-1;
rightSPISpec=estspecnorm(dataMatrix-(dataMatrix*LowRankApprox.V)*LowRankApprox.V')/S(6,6)-1;
% 
% s=count2;l=floor(n*T/m);d=(n*T-m*s)/n;d=floor(d);
% lowrankSketchbackup=Sketch('A',dataMatrix,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',0,'mixedPrecision',0,'fixedW',0,'Y_in_C',0);
% LowRankApprox1=LowRankApproxmation(lowrankSketchbackup);
load(['dataBestT/BestT',num2str(T),'_',num2str(count2),'.mat']);
leftTYUC=norm(dataMatrix-LowRankApprox1.U*(LowRankApprox1.U'*dataMatrix),'fro')/normAbest-1;
rightTYUC=norm(dataMatrix-(dataMatrix*LowRankApprox1.V)*LowRankApprox1.V','fro')/normAbest-1;
load(['dataBestT/BestT',num2str(T),'_',num2str(count2Spec),'.mat']);
leftTYUCSpec=estspecnorm(dataMatrix-LowRankApprox1.U*(LowRankApprox1.U'*dataMatrix))/S(6,6)-1;
rightTYUCSpec=estspecnorm(dataMatrix-(dataMatrix*LowRankApprox1.V)*LowRankApprox1.V')/S(6,6)-1;

% relativeErrorRSVD
% relativeErrorRSVDSpec
minTYUC17
leftTYUC
rightTYUC
minTYUC17Spec
leftTYUCSpec
rightTYUCSpec
minSPI
leftSPI
rightSPI
minSPISpec
leftSPISpec
rightSPISpec

%%
% RSVDSpec=norm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix)/S(6,6)-1
% 
% minSPISpec=norm(dataMatrix-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V')/S(6,6)-1

% 
% minTYUCSpec=norm(dataMatrix-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V')/S(6,6)-1
% leftTYUCSpec=norm(dataMatrix-LowRankApprox1.U*(LowRankApprox1.U'*dataMatrix))/S(6,6)-1
% rightTYUCSpec=norm(dataMatrix-(dataMatrix*LowRankApprox1.V)*LowRankApprox1.V')/S(6,6)-1

%%
% diagS=S;diagSPS=diag(LowRankApprox.S);diagTYUC=diag(LowRankApprox1.S);diagRSVD=diag(SS);
% YList=[diagS(1:r)';diagSPS(1:r)';diagTYUC(1:r)';diagRSVD(1:r)'];
% paintFunc(@semilogy,1:r,YList,{'-',':','--','-.'},{'exact','TYUC17-SPS q=1','TYUC17','RSVD'});
% semilogy(diag(S),'DisplayName','exact');hold on;
% semilogy(diag(LowRankApprox.S),'DisplayName','TYUC17-SPS q=1');
% semilogy(diag(LowRankApprox1.S),'DisplayName','TYUC17');
% semilogy(diag(St(1:r,1:r)),'DisplayName','svdSketch');
% semilogy(diag(SS),'DisplayName','RSVD'); hold off;legend('Location','best');
% normA=norm(U(:,1:r)*S(1:r,1:r)*V(:,1:r)'-dataMatrix,'fro');
% err1=norm(LowRankApprox.U*LowRankApprox.S*LowRankApprox.V'-dataMatrix,'fro')/normA-1;
% err0=norm(LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V'-dataMatrix,'fro')/normA-1;
% errrsvd=norm(QQ*UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-dataMatrix,'fro')/normA-1;