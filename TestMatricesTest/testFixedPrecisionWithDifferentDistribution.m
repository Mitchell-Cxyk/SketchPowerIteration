function testFixedPrecisionWithDifferentDistribution(decay,decayRate,distribution)
fileName=['data/',decay,'_',num2str(decayRate),'_single_fp_',distribution,'.mat'];
if ~exist(fileName)
addpath('../');
% Store the data
MentoCarloNum=20;
A=GenerateData(1000,1000,decay,decayRate,10);
% fileName=['data/',decay,'_',num2str(decayRate),'_single_fp.mat'];
%     TlistPre=load(fileName,'Tlist');
%     TlistPre=TlistPre.Tlist;
    TlistPre=[];
    % errListPre=load(fileName,'errList');
    % errListPre=errListPre.errList;
    errListPre=[];
r=10;
Tlist=24:2:40;
Tlist=[Tlist,42:4:58];
Tlist=[Tlist,60:5:80];
Tlist=[Tlist,90:10:150];
% Tlist=[Tlist,160:20:220];
Tlist=[Tlist,TlistPre];
Tlist=unique(Tlist);
    Tlist1=Tlist;
    [~,indexPre]=ismember(TlistPre,Tlist);
    index=setdiff(1:numel(Tlist),indexPre);
    Tlist=setdiff(Tlist,TlistPre);
iterlist=[1,2,3,0];
errList=zeros(numel(Tlist),numel(iterlist), Tlist1(end)+1, Tlist1(end)+1);
    errList1=zeros(numel(Tlist1),numel(iterlist), Tlist1(end)+1, Tlist1(end)+1);
    storeList=errList;
storeList=errList;
for iterT=1:numel(Tlist)
    decay
    decayRate
    T=Tlist(iterT)
[U,S,V]=tsvd(A,r);
normAbest=norm(A-U*S*V','fro');
for iterMento=1:MentoCarloNum
    lowrankSketchbackup=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution',lower(distribution),'iterationNum',1,'mixedPrecision',1,'fixedW',0);
    for iterq=1:numel(iterlist)
        lowrankSketch=lowrankSketchbackup.copy();
        lowrankSketch.iterationNum=iterlist(iterq);
        if iterlist(iterq)==0
            lowrankSketch.mixedPrecision=0;
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
                    errlowrank = norm(A - lowrankApprox.U * lowrankApprox.S * lowrankApprox.V', 'fro')/normAbest-1;
                    errList(iterT,iterq, s, d) = errlowrank;
                end
            
        end
    end
    storeList=storeList+errList;
end
end

errList = storeList / MentoCarloNum;
errList1(indexPre,:,1:size(errListPre,3),1:size(errListPre,4))=errListPre;
    errList1(index,:,:,:)=errList;
    errList=errList1;
    Tlist=Tlist1;

save(fileName,"errList","Tlist");
end
end
% Plot results
% for iterq=1:numel(iterlist)
%     figure;
%     hold on;
%     for s=1:T
%         for d=1:T
%             l = 2*T - s - d;
%             if s + d <= T && s + l + d == 2*T && s < d && s < l
%                 plot3(s, d, errList(iterq, s, d), 'o');
%             end
%         end
%     end
%     hold off;
%     xlabel('s');
%     ylabel('d');
%     zlabel('Error');
%     title(['IterationNum = ', num2str(iterlist(iterq))]);
% end
