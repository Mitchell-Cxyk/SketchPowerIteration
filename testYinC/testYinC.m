function testYinC(decay,decayRate)
    addpath('../');
    % Store the data
    MentoCarloNum=20;
    A=GenerateData(1000,1000,decay,decayRate,10);
    r=10;
    %set the Tlist
    Tlist=24:2:40;
    Tlist=[Tlist,42:4:60];
    Tlist=[Tlist,60:5:80];
    Tlist=[Tlist,90:10:150];
    % Tlist=[Tlist,160:20:220];
    iterlist=[1,2,3,0];
    errList=zeros(numel(Tlist),numel(iterlist), Tlist(end)+1, Tlist(end)+1);
    storeList=errList;
    for iterT=1:numel(Tlist)
        decay
        decayRate
        T=Tlist(iterT)
    [U,S,V]=tsvd(A,r);
    normAbest=norm(A-U*S*V','fro');
    for iterMento=1:MentoCarloNum
        lowrankSketchbackup=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',1,'mixedPrecision',1,'fixedW',1,'Y_in_C',1);
        lowrankSketchbackup1=Sketch('A',A,'r',r,'s',T,'l',T,'d',T,'distribution','sparsesign','iterationNum',0,'mixedPrecision',0,'fixedW',1,'Y_in_C',1);
        for iterq=1:numel(iterlist)
            if iterlist(iterq)==0
                % lowrankSketch.mixedPrecision=0;
                lowrankSketch=lowrankSketchbackup1.copy();
            elseif iterlist(iterq)>0
                lowrankSketch=lowrankSketchbackup.copy();
                lowrankSketch.iterationNum=iterlist(iterq);
            end
            for s=r:T
                d=T-s;
                    l = 2*s;
                    if  s < 2*d && s < l
                        lowrankSketch.s = s;
                        lowrankSketch.l = l;
                        lowrankSketch.d = 2*d;
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
    fileName=['data/',decay,'_',num2str(decayRate),'_fixedW1_YinC_fp5.mat'];
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
    