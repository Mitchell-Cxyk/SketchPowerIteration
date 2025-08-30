% paintList={{'lowrank',0.1,0.01,0.0001},{'poly',0.5,1,2},{'exp',0.01,0.1,0.5}};
% paintList={{'lowrank',0.1,0.01,0.0001}};
paintList={{'lowrank',0.1},{'poly',3},{'exp',0.01}};
% paintList={{'poly',1}};
% paintList={{'exp',0.5}};
% paintList={{'poly',0.1,0.5,1,2}};
% paintList={{'exp',0.01,0.1,0.5}};
paintSum=0;
mkdir('figure/SketchSingularValue');
for iter=1:numel(paintList)
    paintSum=paintSum+numel(paintList{iter})-1;
end
m=1000;n=1000;mn=min(m,n);r=10;s=20;
SList=zeros(paintSum,mn);
SketchList=zeros(paintSum,s);
SDecayList=zeros(paintSum,mn-1);
SketchDecayList=zeros(paintSum,s-1);
paintOrder=0;
for iter=1:numel(paintList)
   paintVec=paintList{iter};
   for iter2=2:numel(paintVec)
       paintOrder=paintOrder+1;
       [A,S]=GenerateData(m,n,paintVec{1},paintVec{iter2},r);
       S=S';
       SList(paintOrder,:)=S;
       SDecayList(paintOrder,:)=calculateDecayRates(S)';
       
       Omega=constructTestMatrix(n,s,'Gaussian');
       AS=A*Omega;
       S1=svd(AS,"econ","vector");
       S1=S1';
       % SketchList(paintOrder,:)=S1/S1(r+1)*S(r+1);
       % SketchList(paintOrder,:)=S1;
       DecayS1=calculateDecayRates(S1);
       SketchDecayList(paintOrder,:)=DecayS1;
       figure;
       paintFunc(@semilogy,r+1:s,S1(r+1:s)./S(r+1:s),{'-'},'DisplayName',{'Origin'},'LineWidthList',{2});
       % hold on;
       % paintFunc(@semilogy,r+1:s,SketchList(iter,r+1:end),{'--'},'DisplayName',{'Sketch'},'LineWidthList',{2});
       % saveas(gcf,strcat('./figure/SketchSingularValue/SketchSingularValue',paintVec{1},'_',num2str(paintVec{iter2}),'.fig'));
   end
end
% figure(1);
% paintFunc(@semilogy,r:s,SList(:,r:s),{'-'},'DisplayName',{'Origin'},'LineWidthList',{2});
% % ylim([1e-14,2]);
% hold on;
% paintFunc(@semilogy,r:s,SketchList(:,r:end),{'--'},'DisplayName',{'Sketch'},'LineWidthList',{2});
% saveas(strcat('./figure/SketchSingularvalue/SketchSingularValue',paintVec{1},'_',paintVec{iter2}));
% figure(2);
% paintFunc(@semilogy,r:s-1,SDecayList(:,r:s-1),{'-'});
% % ylim([1e-14,2]);
% hold on;
% paintFunc(@semilogy,r:s-1,SketchDecayList(:,r:end),{'--'});
