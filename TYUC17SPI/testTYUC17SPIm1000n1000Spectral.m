function testTYUC17SPIm1000n1000Spectral(decay,decayRate)
addpath('../');
% Store the data
MentoCarloNum=10;
A=GenerateData(1000,1000,decay,decayRate,10);
r=10;
Tlist=24:2:40;
Tlist=[Tlist,42:4:60];
Tlist=[Tlist,60:5:80];
Tlist=[Tlist,90:10:150];
% Tlist=[Tlist,160:20:220];
Tlist=unique(Tlist);
iterlist=[1,2,3,0];
errList=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
storeList=errList;
for iterT=1:numel(Tlist)
    decay
    decayRate
    T=Tlist(iterT)
[U,S,V]=tsvd(A,r);
normAbest=norm(A-U*S*V');
for iterMento=1:MentoCarloNum
    % lowrankSketchbackup=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',1,'mixedPrecision',1,'fixedW',0);
    % lowrankSketchbackup1=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',0);
    lowrankSketchbackup=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',0);
    lowrankSketchbackup1=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','gaussian','iterationNum',0,'mixedPrecision',0,'fixedW',0);
    for iterq=1:numel(iterlist)
        lowrankSketch=lowrankSketchbackup.copy();
        lowrankSketch.iterationNum=iterlist(iterq);
        if iterlist(iterq)==0
            lowrankSketch=lowrankSketchbackup1.copy();
        else
            lowrankSketch.mixedPrecision=1;
        end
        for s=r:T
            d=T-s;
                l = T;
                if s + d == T && s < d && s < l
                    lowrankSketch.s = s;
                    lowrankSketch.l = l;
                    lowrankSketch.d = d;
                    lowrankSketch = lowrankSketch.ModifySketch();
                    lowrankApprox = LowRankApproxmation(lowrankSketch);
                    errlowrank = norm(A - lowrankApprox.U * lowrankApprox.S * lowrankApprox.V')/normAbest-1;
                    errList(iterT,iterq, s, d) = errlowrank;
                end
            
        end
    end
    storeList=storeList+errList;
end
end

errList = storeList / MentoCarloNum;
fileName=['data/',decay,'_',num2str(decayRate),'_TYUC17SPIStandardSpectral.mat'];
save(fileName,"errList","Tlist");
end