function [errF,errS]=testClimateError(A,T,r,tol)
errF=zeros(3,10);errS=zeros(3,10);% RSVD,TYUC17,TYUC17SPI
savefilename=['dataNewPara/ErrorClimate_',num2str(T),'_',num2str(r),'.mat'];
% load(savefilename);
for iter=1:10
fileName=['dataNewPara/SingularVectorPoly77_',num2str(T),'_',num2str(iter),'.mat'];
data=load(fileName);
if size(data.UU,2)>=r
errF(1,iter)=norm(A-data.UU(:,1:r)*data.SS(1:r,1:r)*data.VV(:,1:r)','fro');
% errS(1,iter)=normest(A-data.UU(:,1:r)*data.SS(1:r,1:r)*data.VV(:,1:r)',tol);
end
if size(data.LowRankApprox.U,2)>=r
% errF(2,iter)=norm(A-data.LowRankApprox.U(:,1:r)*data.LowRankApprox.S(1:r,1:r)*data.LowRankApprox.V(:,1:r)','fro');
errF(2,iter)=norm(A-data.LowRankApprox.U(:,1:r)*(data.LowRankApprox.U(:,1:r)'*A*data.LowRankApprox.V(:,1:r))*data.LowRankApprox.V(:,1:r)','fro');
% errS(2,iter)=normest(A-data.LowRankApprox.U(:,1:r)*data.LowRankApprox.S(1:r,1:r)*data.LowRankApprox.V(:,1:r)',tol);
end
if size(data.LowRankApprox1.U,2)>=r
errF(3,iter)=norm(A-data.LowRankApprox1.U(:,1:r)*data.LowRankApprox1.S(1:r,1:r)*data.LowRankApprox1.V(:,1:r)','fro');
% errS(3,iter)=normest(A-data.LowRankApprox1.U(:,1:r)*data.LowRankApprox1.S(1:r,1:r)*data.LowRankApprox1.V(:,1:r)',tol);
end
end
% savefilename=['data/ErrorClimate_',num2str(T),'_',num2str(r),'.mat'];
save(savefilename,"errF","errS");
end