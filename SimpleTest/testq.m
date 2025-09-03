m=1000;n=1000;
A=GenerateData(m,n,'poly',0.5,10);
r=10;l=60;s=20;MentoCarloNum=50;d=l-s;
Phi=randn(n,l);Z=A*Phi;Psi=randn(d,m);W=Psi*A;
qlist=[1:10,12:2:20];
errF=zeros(MentoCarloNum,numel(qlist));
errS=zeros(MentoCarloNum,numel(qlist));
for iter=1:MentoCarloNum
    iter
    % Phi=randn(n,l);Z=A*Phi;
    Omega=randn(n,s);
    Y=A*Omega;
    for iterq=1:numel(qlist)
        q=qlist(iterq)
        for iter1=1:q
            Y1=Z'*Y;
            [Y1,~]=qr(Y1,0);
            Y=Z*Y1;
        end
        [Q,~]=qr(Y,0);
        B=(Psi*Q)\W;
        [U,S,V]=svd(B,'econ');
        U=U(:,1:r);S=S(1:r,1:r);V=V(:,1:r);U=Q*U;
        errF(iter,iterq)=norm(A-U*S*V','fro');
        errS(iter,iterq)=norm(A-U*S*V');
    end
end
save('testq_poly_0.5FixedPhiPsi.mat','errF','errS');
