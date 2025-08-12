A=GenerateData(1000,1000,'poly',1,10);
T=96;
m=1000;n=1000;errList96=[];
S=svd(A);
errBest=norm(S(11:end));r=10;
for s=11:48
    d=T-s;
    % Omega=randn(n,s);
    % Psi=randn(d,m);
    % Y=A*Omega;
    % W=Psi*A;
    % [Q,~]=qr(Y,'econ');
    % B=(Psi*Q)\W;
    % [U,S,V]=svd(B,'econ');
    % U=U(:,1:10);S=S(1:10,1:10);V=V(:,1:10);
    % U=Q*U;
    lowrankSketch=Sketch('A',A,'r',r,'s',s,'l',T,'d',d,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',0);
    lowrankApprox = LowRankApproxmation(lowrankSketch);
    err=norm(A-lowrankApprox.U*lowrankApprox.S*lowrankApprox.V','fro')/errBest-1;
    errList96(end+1)=err;
end
errmin=min(errList96)
