%T=320 may be use the exact spectral norm instead of normest.
Tlist=40:20:320;
ErrListF=zeros(3,numel(Tlist));
ErrListSpec=zeros(3,numel(Tlist));
r=10;
load("NIST20000.mat");
load("NIST100k.mat");
ErrBestF=norm(imageMatrix20000-U(:,1:10)*S(1:10,1:10)*V(:,1:10)','fro');
ErrBestSpec=S(11,11);
for iter=1:numel(Tlist)
    T=Tlist(iter);
    savefilename=['data/Error_',num2str(T),'_',num2str(r),'.mat'];
    data=load(savefilename);
    ErrListF(:,iter)=sum(data.errF,2)/10;
    ErrListSpec(:,iter)=sum(data.errS,2)/10;
end
ErrListF=ErrListF./ErrBestF-1;
ErrListSpec=ErrListSpec./ErrBestSpec-1;
save("Relative_r10.mat","ErrListSpec","ErrListF");
%%
Tlist=40:20:320;
ErrListF=zeros(3,numel(Tlist));
ErrListSpec=zeros(3,numel(Tlist));
r=5;
load("NIST20000.mat");
load("NIST100k.mat");
ErrBestF=norm(imageMatrix20000-U(:,1:6)*S(1:6,1:6)*V(:,1:6)','fro');
ErrBestSpec=S(6,6);
for iter=1:numel(Tlist)
    T=Tlist(iter);
    savefilename=['data/Error_',num2str(T),'_',num2str(r),'.mat'];
    data=load(savefilename);
    ErrListF(:,iter)=sum(data.errF,2)/10;
    ErrListSpec(:,iter)=sum(data.errS,2)/10;
end
ErrListF=ErrListF./ErrBestF-1;
ErrListSpec=ErrListSpec./ErrBestSpec-1;
save("Relative_r5.mat","ErrListSpec","ErrListF");