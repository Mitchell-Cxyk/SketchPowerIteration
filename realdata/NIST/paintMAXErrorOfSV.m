changeCurrentFolderToScriptFolder();
DisplaySingularVectorIndex=[1,2,3,4];
Tlist=40:20:320;
ErrListMAX=zeros(3,numel(Tlist),numel(DisplaySingularVectorIndex));
ErrListMAIN=zeros(3,numel(Tlist),numel(DisplaySingularVectorIndex));
ErrListStoreMAX=ErrListMAX;
ErrListStoreMAIN=ErrListMAIN;
    load('NIST100k.mat');
MentoCarloNum=5;ErrList=zeros(3,numel(Tlist),MentoCarloNum);ErrList2=zeros(3,numel(Tlist),MentoCarloNum);
% iterMento=2;
for iter=1:numel(Tlist)
    for iterMento=1:MentoCarloNum
    load(['data/SingularVector_',num2str(Tlist(iter)),'_',num2str(iterMento),'.mat']);
    [angels,sines,cosines]=canonical_angles(LowRankApprox.U,U,1);
    ErrList(1,iter,iterMento)=sines(1);
    [angels,sines,cosines]=canonical_angles(LowRankApprox1.U,U,1);
    ErrList(2,iter,iterMento)=sines(1);
    [angels,sines,cosines]=canonical_angles(UU,U,1);
    ErrList(3,iter,iterMento)=sines(1);
    [angels,sines,cosines]=canonical_angles(LowRankApprox.U,U,2);
    ErrList2(1,iter,iterMento)=sines(2);
    [angels,sines,cosines]=canonical_angles(LowRankApprox1.U,U,2);
    ErrList2(2,iter,iterMento)=sines(2);
    [angels,sines,cosines]=canonical_angles(UU,U,2);
    ErrList2(3,iter,iterMento)=sines(2);
    end
end
    ErrListMean=mean(ErrList,3);
    ErrListMean2=mean(ErrList2,3);
    % ErrorSPS=abs(LowRankApprox.U)-abs(U(:,1:size(LowRankApprox.U,2)));
    % ErrorTYUC17=abs(LowRankApprox1.U)-abs(U(:,1:size(LowRankApprox1.U,2)));
    % ErrorRSVD=abs(UU(:,1:size(LowRankApprox1.U,2)))-abs(U(:,1:size(LowRankApprox1.U,2)));
    % SErrSPS=max(ErrorSPS,[],1);
    % SErrSPSMean=sqrt(mean(ErrorSPS.^2,1));
    % SErrTYUC17=max(ErrorTYUC17,[],1);
    % SErrTYUC17Mean=sqrt(mean(ErrorTYUC17.^2,1));
    % SErrRSVD=max(ErrorRSVD,[],1);
    % SErrRSVDMean=sqrt(mean(ErrorRSVD.^2,1));
    % ErrListMAX(1,iter,:)=SErrSPS(DisplaySingularVectorIndex);
    % ErrListMAX(2,iter,:)=SErrTYUC17(DisplaySingularVectorIndex);
    % ErrListMAX(3,iter,:)=SErrRSVD(DisplaySingularVectorIndex);
    % ErrListMAIN(1,iter,:)=SErrSPSMean(DisplaySingularVectorIndex);
    % ErrListMAIN(2,iter,:)=SErrTYUC17Mean(DisplaySingularVectorIndex);
    % ErrListMAIN(3,iter,:)=SErrRSVDMean(DisplaySingularVectorIndex);
    % end
    % ErrListStoreMAX=ErrListStoreMAX+ErrListMAX;
    % ErrListStoreMAIN=ErrListStoreMAIN+ErrListMAIN;
%%
figure;
paintFunc(@semilogy,Tlist,ErrListMean,{':','-','-.'},'DisplayName',{'SPI q=1','TYUC17','RSVD'},'ColorOrder',[1,4,7]);

xlabel('storage budget: T');
ylabel('$\sin(\theta_1)$','Interpreter','latex');
saveas(gcf,"figure/NISTSingularVector/SingularVectorError/NISTSingularVector_Error_order1.fig");



figure;
paintFunc(@semilogy,Tlist,ErrListMean2,{':','-','-.'},'DisplayName',{'SPI q=1','TYUC17','RSVD'},'ColorOrder',[1,4,7]);
xlabel('storage budget: T');
ylabel('$\sin(\theta_2)$','Interpreter','latex');

saveas(gcf,"figure/NISTSingularVector/SingularVectorError/NISTSingularVector_Error_order2.fig");