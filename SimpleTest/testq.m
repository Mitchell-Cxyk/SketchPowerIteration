m=1000;m=1000;
A=GenerateData(m,n,'poly',1,10);
r=10;l=60;s=20;MentoCarloNum=50;

qlist=[1:10,12:2:20,25:5:100];
errF=zeros(MentoCarloNum,numel(qlist));
errS=zeros(MentoCarloNum,numel(qlist));
for iter=1:MentoCarloNum
    iter
    Phi=randn(n,l);Z=A*Phi;
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
        errF(iter,iterq)=norm(A-Q*(Q'*A),'fro');
        errS(iter,iterq)=norm(A-Q*(Q'*A));
    end
end
save('testq2.mat','errF','errS');
