
r=10; T=300; m=10512; n=28144;decay='poly';decayRate=0.42;MenteCarloNum=10;
for T=30:20:290
    for iterMento=1:MenteCarloNum
s=floor(ParameterGuide(n,T,r,decay,decayRate,m/n));
% s=31;
l=floor(n*T/m);d=(n*T-m*s)/n;d=floor(d);
% r=20; s=50;l=100;d=100;
% [U,S,V]=svds(dataMatrix,100);
% errList=[];
% for s=r:T/2-1
% d=T-s;
lowrankSketchbackup=Sketch('A',dataMatrix,'r',r,'s',s,'l',l,'d',d,'distribution','sparseRademacher','iterationNum',1,'mixedPrecision',1,'fixedW',0,'Y_in_C',0);
LowRankApprox=LowRankApproxmation(lowrankSketchbackup);
% norm(lowrankSketchbackup.A-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V','fro')
% end
s=floor(T/3);
% s=T/2-1;
% T=T/2;
% s=max(r+2,floor((T-1)*((sqrt(r*(T-r-2)*(1-2/(T-1)))-(r-1))/(T-2*r-1))));
% T=T*2;
% s=31;
d=n*T-m*s;d=floor(d/n);
lowrankSketchbackup1=Sketch('A',dataMatrix,'r',r,'s',s,'l',l,'d',d,'distribution','sparseRademacher','iterationNum',0,'mixedPrecision',0,'fixedW',0,'Y_in_C',0);
LowRankApprox1=LowRankApproxmation(lowrankSketchbackup1);

% norm(lowrankSketchbackup.A-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro');
s=floor(T*n/(m+n));
Y=dataMatrix*randn(size(dataMatrix,2),s);
[QQ,~]=qr(double(Y),0);
BB=QQ'*dataMatrix;
[UU,SS,VV]=svd(BB,'econ');
UU=QQ*UU;
save(['dataNewPara/SingularVectorPoly42_',num2str(T),'_',num2str(iterMento),'.mat'],"LowRankApprox","LowRankApprox1","UU","SS","VV","T",'-v7.3');
    end
end

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