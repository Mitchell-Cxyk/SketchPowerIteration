T=190;r=10;
[m,n]=size(imageMatrix20000);
A=imageMatrix20000;
normAbest=norm(imageMatrix20000-U(:,1:r)*S(1:r,1:r)*V(:,1:r)','fro');
normSbest=S(r+1,r+1);
errList=zeros(2,3);
errListSpec=zeros(2,3);
s=ParameterGuide(n,T,r,'poly',0.69);
d=T-s;l=T;
lowrankSketchbackup=Sketch('A',imageMatrix20000,'r',r,'s',s,'l',l,'d',d,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',0,'Y_in_C',0);
for iter=1:3
lowrankSketchbackup.iterationNum=iter;
lowrankapprox=LowRankApproxmation(lowrankSketchbackup);
errList(1,iter)=norm(A-lowrankapprox.U*lowrankapprox.S*lowrankapprox.V','fro')/normAbest-1;
errList(2,iter)=norm(A-lowrankapprox.U*(lowrankapprox.U'*imageMatrix20000),'fro')/normAbest-1;

errListSpec(1,iter)=estspecnorm(A-lowrankapprox.U*lowrankapprox.S*lowrankapprox.V')/normSbest-1;
errListSpec(2,iter)=estspecnorm(A-lowrankapprox.U*(lowrankapprox.U'*imageMatrix20000))/normSbest-1;
end