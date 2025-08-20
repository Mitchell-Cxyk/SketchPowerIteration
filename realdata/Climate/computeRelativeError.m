%T=320 may be use the exact spectral norm instead of normest.
Tlist=30:20:290;
ErrListF=zeros(3,numel(Tlist));
ErrListSpec=zeros(3,numel(Tlist));
r=10;
load("dataMatrix.mat");
load("dataMatrixS100.mat");
ErrBestF=norm(dataMatrix-U(:,1:10)*S(1:10,1:10)*V(:,1:10)','fro');
ErrBestSpec=S(11,11);
for iter=1:numel(Tlist)
    T=Tlist(iter);
    savefilename=['dataNewPara/ErrorClimate_',num2str(T),'_',num2str(r),'.mat'];
    data=load(savefilename);
    ErrListF(1,iter)=max(data.errF(1,:));
    ErrListF(2,iter)=min(data.errF(2,:));
    ErrListF(3,iter)=min(data.errF(3,:));
    
    ErrListSpec(:,iter)=sum(data.errS,2)/10;
end
ErrListF=ErrListF./ErrBestF-1;
% ErrListSpec=ErrListSpec./ErrBestSpec-1;
save("Relative_r10.mat","ErrListSpec","ErrListF");
%%
Tlist=30:20:290;
ErrListF=zeros(3,numel(Tlist));
ErrListSpec=zeros(3,numel(Tlist));
r=5;
load("dataMatrix.mat");
load("dataMatrixS100.mat");
ErrBestF=norm(dataMatrix-U(:,1:r)*S(1:r,1:r)*V(:,1:r)','fro');
ErrBestSpec=S(r+1,r+1);
for iter=1:numel(Tlist)
    T=Tlist(iter);
    savefilename=['dataNewPara/ErrorClimate_',num2str(T),'_',num2str(r),'.mat'];
    data=load(savefilename);
    ErrListF(1,iter)=max(data.errF(1,:));
    ErrListF(2,iter)=min(data.errF(2,:));
    ErrListF(3,iter)=min(data.errF(3,:));
    
    ErrListSpec(:,iter)=sum(data.errS,2)/10;
end
ErrListF=ErrListF./ErrBestF-1;
% ErrListSpec=ErrListSpec./ErrBestSpec-1;
save(['Relative_r',num2str(r),'.mat'],"ErrListSpec","ErrListF");