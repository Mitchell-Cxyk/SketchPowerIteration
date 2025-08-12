function testTYUC17SPIm1000n1000(decay,decayRate)
addpath('../');
% Store the data
MentoCarloNum=1;
A=GenerateData(1000,1000,decay,decayRate,10);
r=10;
Tlist=24:2:40;
Tlist=[Tlist,42:4:60];
Tlist=[Tlist,60:5:80];
Tlist=[Tlist,90:10:150];
% Tlist=[96];
% Tlist=[Tlist,160:20:220];
Tlist=unique(Tlist);
iterlist=[1,2,3,0];
errList=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
errListSpec=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
storeList=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
storeListSpec=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
for iterT=1:numel(Tlist)
    decay
    decayRate
    T=Tlist(iterT)
[U,S,V]=tsvd(A,r+1);
normASpectralbest=S(r+1,r+1);
U=U(:,1:r);V=V(:,1:r);S=S(1:r,1:r);
normAbest=norm(A-U*S*V','fro');
for iterMento=1:MentoCarloNum
    % lowrankSketchbackup=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',1,'mixedPrecision',1,'fixedW',0);
    % lowrankSketchbackup1=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',0);
   
        % lowrankSketch=lowrankSketchbackup.copy();
        % lowrankSketch.iterationNum=iterlist(iterq);
        for s=r:T
            d=T-s;
                l = T;
                if s + d == T && s < d && s < l
                    lowrankSketch=Sketch('A',A,'r',r,'s',s,'l',l,'d',d,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',0);
                    % lowrankSketch.s = s;
                    % lowrankSketch.l = l;
                    % lowrankSketch.d = d;
                    % lowrankSketch = lowrankSketch.ModifySketch();
                    for iterq=1:numel(iterlist)
                    if iterlist(iterq)==0
                        % lowrankSketch=Sketch('A',A,'r',r,'s',s,'l',l,'d',d,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',0);
                        lowrankSketch.mixedPrecision=0;
                        lowrankSketch.iterationNum=iterlist(iterq);
                    else
                        lowrankSketch.mixedPrecision=1; 
                        lowrankSketch.iterationNum=iterlist(iterq);
                    end
                    % iterlist(iterq)
                    lowrankApprox = LowRankApproxmation(lowrankSketch);
                    errlowrank = norm(A - lowrankApprox.U * lowrankApprox.S * lowrankApprox.V', 'fro')/normAbest-1;
                    errlowrankSpectral=norm(A - lowrankApprox.U * lowrankApprox.S * lowrankApprox.V')/normASpectralbest-1;
                    errList(iterT,iterq, s, d) = errlowrank;
                    errListSpec(iterT,iterq, s, d)=errlowrankSpectral;
                    end
            
                end
        end
    % storeList=storeList+errList;
    % storeListSpec=storeListSpec+errListSpec;
end
end

% errList = storeList / MentoCarloNum;
% errListSpec=storeListSpec/MentoCarloNum;
fileName=['data/',decay,'_',num2str(decayRate),'_TYUC17SPIStandard.mat'];
save(fileName,"errList","errListSpec","Tlist");
end