
r=10; T=96; m=16384; n=20000;decay='poly';decayRate=0.7241;MenteCarloNum=10;
for T=40:20:320
    for iterMento=1:MenteCarloNum
s=floor(ParameterGuide(20000,T,r,decay,decayRate));

l=T;d=T-s;

lowrankSketchbackup=Sketch('A',imageMatrix20000,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',0,'Y_in_C',0);
LowRankApprox=LowRankApproxmation(lowrankSketchbackup);
norm(lowrankSketchbackup.A-LowRankApprox.U*LowRankApprox.S*LowRankApprox.V','fro')
% end
s=floor(T/3);
d=floor(T-s);
lowrankSketchbackup.s=s;lowrankSketchbackup.d=d;
lowrankSketchbackup.iterationNum=0;
lowrankSketchbackup.ModifySketch();
LowRankApprox1=LowRankApproxmation(lowrankSketchbackup);

norm(lowrankSketchbackup.A-LowRankApprox1.U*LowRankApprox1.S*LowRankApprox1.V','fro')

s=T/2;
Y=imageMatrix20000*randn(20000,s);
[QQ,~]=qr(double(lowrankSketchbackup.Y),0);
BB=QQ'*imageMatrix20000;
[UU,SS,VV]=svd(BB,'econ');
UU=QQ*UU;
save(['data/SingularVector_',num2str(T),'_',num2str(iterMento),'.mat'],"LowRankApprox","LowRankApprox1","UU","SS","VV","T",'-v7.3');
    end
end


%%
diagS=diag(S);diagSPS=diag(LowRankApprox.S);diagTYUC=diag(LowRankApprox1.S);diagRSVD=diag(SS);
YList=[diagS(1:r)';diagSPS(1:r)';diagTYUC(1:r)';diagRSVD(1:r)'];
paintFunc(@semilogy,1:r,YList,{'-',':','--','-.'},'DisplayName',{'exact','TYUC17-SPS q=1','TYUC17','RSVD'});
