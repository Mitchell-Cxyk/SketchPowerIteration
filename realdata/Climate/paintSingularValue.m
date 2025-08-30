changeCurrentFolderToScriptFolder();
r=5;
Tlist=270;iterMento=1;
for iter=1:numel(Tlist)
load(['dataNewPara/SingularVectorPoly68_',num2str(Tlist(iter)),'_',num2str(iterMento),'.mat']);
load('dataMatrixS100.mat');
figure;
diagS=diag(S);diagSPS=diag(LowRankApprox.S);diagTYUC=diag(LowRankApprox1.S);diagRSVD=diag(SS);
YList=[diagS(1:r)';diagSPS(1:r)';diagTYUC(1:r)';diagRSVD(1:r)'];
paintFunc(@semilogy,1:r,YList,{'-',':','--','-.'},'DisplayName',{'exact','SPI q=1','TYUC17','RSVD'},'ColorOrder',[8,1,4,7]);
% saveas(gcf,strcat("figure/NISTSingularValue/SingularValueNIST_r",num2str(r),"_T",num2str(Tlist(iter)),".fig"));
end