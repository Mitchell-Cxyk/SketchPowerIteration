
m=16384; n=20000;
r=10; 
errList=zeros(3,320);
errListSpec=zeros(3,290);
% imageMatrix20000=imageMatrix20000';
for T=260
for s=r:T
s
% s=floor(ParameterGuide(n,T,r,decay,decayRate,m/n));
% s=31;
l=T;d=T-s;
if l<=s || d<=s
    disp('continue..');
    continue;
end
% r=20; s=50;l=100;d=100;
% [U,S,V]=svds(imageMatrix20000,100);
% errList=[];
% for s=r:T/2-1
% d=T-s;
lowrankSketchbackup=Sketch('A',imageMatrix20000,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',0,'Y_in_C',0);
LowRankApprox=LowRankApproxmation(lowrankSketchbackup);
relativeErrorSPI=norm(imageMatrix20000-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V','fro');
errList(1,s)=relativeErrorSPI;
errListSpec(1,s)=normest(imageMatrix20000-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V');
lowrankSketchbackup.iterationNum=0;
lowrankSketchbackup.mixedPrecision=0;
LowRankApprox1=LowRankApproxmation(lowrankSketchbackup);
errList(2,s)=norm(imageMatrix20000-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro');
errListSpec(2,s)=normest(imageMatrix20000-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V');
filename=['dataBestT/BestTSquare',num2str(T),'_',num2str(s),'.mat'];
save(filename,'LowRankApprox','LowRankApprox1');
% end
% s=floor(T/3);
% % s=T/2-1;
% % T=T/2;
% % s=max(r+2,floor((T-1)*((sqrt(r*(T-r-2)*(1-2/(T-1)))-(r-1))/(T-2*r-1))));
% % T=T*2;
% % s=31;
% d=n*T-m*s;d=floor(d/n);
% lowrankSketchbackup1=Sketch('A',imageMatrix20000,'r',r,'s',s,'l',l,'d',d,'distribution','sparseRademacher','iterationNum',0,'mixedPrecision',0,'fixedW',0,'Y_in_C',0);
% LowRankApprox1=LowRankApproxmation(lowrankSketchbackup1);

% norm(lowrankSketchbackup.A-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro');
end
s=T/2;
Y=imageMatrix20000*randn(size(imageMatrix20000,2),s);
[QQ,~]=qr(double(Y),0);
BB=QQ'*imageMatrix20000;
[UU,SS,VV]=svd(BB,'econ');
UU=QQ*UU;
relativeErrorRSVD=norm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-imageMatrix20000,'fro')/normAbest-1;
% relativeErrorRSVDSpec=normest(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-imageMatrix20000)/S(r+1,r+1)-1;
filename=['dataBestT/ErrList',num2str(T),'.mat'];
save(filename,'errList','UU','SS','VV');
errList(errList==0)=Inf;
[minSPI,count]=min(errList(1,:));
% minSPI=minSPI/normAbest-1;
errListSpec(errListSpec==0)=Inf;
[minTYUC17,count2]=min(errList(2,:));
% minTYUC17=minTYUC17/normAbest-1;
[minSPISpec,countSpec]=min(errListSpec(1,:));
[minTYUC17Spec,count2Spec]=min(errListSpec(2,:));
end

%%


load(['dataBestT/BestTSquare',num2str(T),'_',num2str(count),'.mat']);
leftSPI=norm(imageMatrix20000-LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000),'fro')/normAbest-1;
rightSPI=norm(LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000)-(LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000)*LowRankApprox.V)*LowRankApprox.V','fro')/normAbest;
%%
load(['dataBestT/BestTSquare',num2str(T),'_',num2str(countSpec),'.mat']);
leftSPISpec=normest(imageMatrix20000-LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000))/S(r+1,r+1)-1;
rightSPISpec=normest(LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000)-(LowRankApprox.U*(LowRankApprox.U'*imageMatrix20000)*LowRankApprox.V)*LowRankApprox.V')/S(r+1,r+1)-1;
% 
% s=count2;l=floor(n*T/m);d=(n*T-m*s)/n;d=floor(d);
% lowrankSketchbackup=Sketch('A',imageMatrix20000,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',0,'mixedPrecision',0,'fixedW',0,'Y_in_C',0);
% LowRankApprox1=LowRankApproxmation(lowrankSketchbackup);
%%
load(['dataBestT/BestTSquare',num2str(T),'_',num2str(count2),'.mat']);
leftTYUC=norm(imageMatrix20000-LowRankApprox1.U*(LowRankApprox1.U'*imageMatrix20000),'fro')/normAbest-1;
rightTYUC=norm(LowRankApprox1.U*(LowRankApprox1.U'*imageMatrix20000)-(LowRankApprox1.U*(LowRankApprox1.U'*imageMatrix20000)*LowRankApprox1.V)*LowRankApprox1.V','fro')/normAbest;
%%
load(['dataBestT/BestTSquare',num2str(T),'_',num2str(count2Spec),'.mat']);
leftTYUCSpec=normest(imageMatrix20000-LowRankApprox1.U*(LowRankApprox1.U'*imageMatrix20000))/S(r+1,r+1)-1;
rightTYUCSpec=normest(imageMatrix20000-(imageMatrix20000*LowRankApprox1.V)*LowRankApprox1.V')/S(r+1,r+1)-1;

% relativeErrorRSVD
% relativeErrorRSVDSpec
%%
disp('------------------------------');
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
% RSVDSpec=norm(UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-imageMatrix20000)/S(r+1,r+1)-1
% 
% minSPISpec=norm(imageMatrix20000-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V')/S(r+1,r+1)-1

% 
% minTYUCSpec=norm(imageMatrix20000-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V')/S(r+1,r+1)-1
% leftTYUCSpec=norm(imageMatrix20000-LowRankApprox1.U*(LowRankApprox1.U'*imageMatrix20000))/S(r+1,r+1)-1
% rightTYUCSpec=norm(imageMatrix20000-(imageMatrix20000*LowRankApprox1.V)*LowRankApprox1.V')/S(r+1,r+1)-1

%%
% diagS=S;diagSPS=diag(LowRankApprox.S);diagTYUC=diag(LowRankApprox1.S);diagRSVD=diag(SS);
% YList=[diagS(1:r)';diagSPS(1:r)';diagTYUC(1:r)';diagRSVD(1:r)'];
% paintFunc(@semilogy,1:r,YList,{'-',':','--','-.'},{'exact','TYUC17-SPS q=1','TYUC17','RSVD'});
% semilogy(diag(S),'DisplayName','exact');hold on;
% semilogy(diag(LowRankApprox.S),'DisplayName','TYUC17-SPS q=1');
% semilogy(diag(LowRankApprox1.S),'DisplayName','TYUC17');
% semilogy(diag(St(1:r,1:r)),'DisplayName','svdSketch');
% semilogy(diag(SS),'DisplayName','RSVD'); hold off;legend('Location','best');
% normA=norm(U(:,1:r)*S(1:r,1:r)*V(:,1:r)'-imageMatrix20000,'fro');
% err1=norm(LowRankApprox.U*LowRankApprox.S*LowRankApprox.V'-imageMatrix20000,'fro')/normA-1;
% err0=norm(LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V'-imageMatrix20000,'fro')/normA-1;
% errrsvd=norm(QQ*UU(:,1:r)*SS(1:r,1:r)*VV(:,1:r)'-imageMatrix20000,'fro')/normA-1;