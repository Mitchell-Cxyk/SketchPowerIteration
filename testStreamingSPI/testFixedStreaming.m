function testFixedStreaming(decay,decayRate)
addpath('../');
% Store the data
MentoCarloNum=10;
A=GenerateData(1000,1000,decay,decayRate,10);
[m,n]=size(A);
r=10;
Tlist=24:2:40;
Tlist=[Tlist,42:5:80];
Tlist=[Tlist,90:10:150];
% Tlist=[Tlist,160:20:220];
iterlist=[1,2,3,0];
errList=zeros(numel(Tlist),numel(iterlist), floor(sqrt(2*Tlist(end)*m)), floor(sqrt(2*Tlist(end)*m)));
storeList=errList;
for iterT=1:numel(Tlist)
    decay
    decayRate
    T=Tlist(iterT)
[U,S,V]=tsvd(A,r);
normAbest=norm(A-U*S*V','fro');
for iterMento=1:MentoCarloNum
    lowrankSketchbackup=StreamingThreeSketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','gaussian','iterationNum',1,'mixedPrecision',1,'fixedW',1);
    for iterq=1:numel(iterlist)
        lowrankSketch=lowrankSketchbackup.copy();
        lowrankSketch.iterationNum=iterlist(iterq);
        if iterlist(iterq)==0
            lowrankSketch.mixedPrecision=0;
        else
            lowrankSketch.mixedPrecision=1;
        end
        for s=r:T
            d=floor(sqrt(2*m*(T-s)));
                l = 2*s;
                if  s < d && s < l
                    lowrankSketch.s = s;
                    lowrankSketch.l = l;
                    lowrankSketch.d = d;
                    lowrankSketch = lowrankSketch.ModifySketch();
                    lowrankApprox = StreamingLowRankApproximation(lowrankSketch);
                    errlowrank = norm(A - lowrankApprox.U * lowrankApprox.S * lowrankApprox.V', 'fro')/normAbest-1;
                    errList(iterT,iterq, s, d) = errlowrank;
                end
            
        end
    end
    storeList(iterT,:,:,:)=storeList(iterT,:,:,:)+errList(iterT,:,:,:);
end
end

errList = storeList / MentoCarloNum;
fileName=['data/',decay,'_',num2str(decayRate),'_streaming_fp.mat'];
save(fileName,"errList","Tlist");
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
