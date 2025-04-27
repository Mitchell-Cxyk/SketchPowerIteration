changeCurrentFolderToScriptFolder();
DisplaySingularVectorIndex=[1,2,3,4];
Tlist=40:20:320;
ErrListMAX=zeros(3,numel(Tlist),numel(DisplaySingularVectorIndex));
ErrListMAIN=zeros(3,numel(Tlist),numel(DisplaySingularVectorIndex));
ErrListStoreMAX=ErrListMAX;
ErrListStoreMAIN=ErrListMAIN;

MentoCarloNum=5;
for iter=1:numel(Tlist)
    for iterMento=1:MentoCarloNum
    load(['data/SingularVector_',num2str(Tlist(iter)),'_',num2str(iterMento),'.mat']);
    load('NIST100k.mat');
    ErrorSPS=abs(LowRankApprox.U)-abs(U(:,1:size(LowRankApprox.U,2)));
    ErrorTYUC17=abs(LowRankApprox1.U)-abs(U(:,1:size(LowRankApprox1.U,2)));
    ErrorRSVD=abs(UU(:,1:size(LowRankApprox1.U,2)))-abs(U(:,1:size(LowRankApprox1.U,2)));
    SErrSPS=max(ErrorSPS,[],1);
    SErrSPSMean=sqrt(mean(ErrorSPS.^2,1));
    SErrTYUC17=max(ErrorTYUC17,[],1);
    SErrTYUC17Mean=sqrt(mean(ErrorTYUC17.^2,1));
    SErrRSVD=max(ErrorRSVD,[],1);
    SErrRSVDMean=sqrt(mean(ErrorRSVD.^2,1));
    ErrListMAX(1,iter,:)=SErrSPS(DisplaySingularVectorIndex);
    ErrListMAX(2,iter,:)=SErrTYUC17(DisplaySingularVectorIndex);
    ErrListMAX(3,iter,:)=SErrRSVD(DisplaySingularVectorIndex);
    ErrListMAIN(1,iter,:)=SErrSPSMean(DisplaySingularVectorIndex);
    ErrListMAIN(2,iter,:)=SErrTYUC17Mean(DisplaySingularVectorIndex);
    ErrListMAIN(3,iter,:)=SErrRSVDMean(DisplaySingularVectorIndex);
    end
    ErrListStoreMAX=ErrListStoreMAX+ErrListMAX;
    ErrListStoreMAIN=ErrListStoreMAIN+ErrListMAIN;
end
ErrListMAX=ErrListStoreMAX/MentoCarloNum;
ErrListMAIN=ErrListStoreMAIN/MentoCarloNum;
%%
figure(1);
paintFunc(@semilogy,Tlist,ErrListMAX(:,:,1),{'-'},'DisplayName',{'SPI q=1','TYUC17','RSVD'},'ColorOrder',[1,4,7]);
hold on;
paintFunc(@semilogy,Tlist,ErrListMAIN(:,:,1),{'--'},'ColorOrder',[1,4,7]);
xlim([50,300]);
hold on;
paintFunc(@semilogy,nan,[nan;nan],{'-','--'},'DisplayName',{'Infty Norm','rescaled Euclidean Norm'},'ColorOrder',[15,15]);
hold off;
saveas(gcf,"figure/NISTSingularVector/SingularVectorError/NISTSingularVector_Error_order1.fig");


figure(2);
paintFunc(@semilogy,Tlist,ErrListMAX(:,:,2),{'-'},'DisplayName',{'SPI q=1','TYUC17','RSVD'},'ColorOrder',[1,4,7]);
hold on;
paintFunc(@semilogy,Tlist,ErrListMAIN(:,:,2),{'--'},'ColorOrder',[1,4,7]);
xlim([50,270]);
hold on;
paintFunc(@semilogy,nan,[nan;nan],{'-','--'},'DisplayName',{'Infty Norm','rescaled Euclidean Norm'},'ColorOrder',[15,15]);
hold off;
saveas(gcf,"figure/NISTSingularVector/SingularVectorError/NISTSingularVector_Error_order2.fig");