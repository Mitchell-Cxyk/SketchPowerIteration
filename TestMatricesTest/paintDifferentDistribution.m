function fig=paintDifferentDistribution(decay,decayRate)
% decay='poly';decayRate=0.5;
filename=[decay,'_',num2str(decayRate),'_single_fp_Gaussian.mat'];
loadData=load(filename);
GaussianError=loadData.errList;

filename=[decay,'_',num2str(decayRate),'_single_fp_SparseRademacher002.mat'];
load(filename);
SparseRademacherError=errList;

filename=[decay,'_',num2str(decayRate),'_single_fp_CountSketch.mat'];
load(filename);
CountSketchError=errList;

filename=[decay,'_',num2str(decayRate),'_single_fp_SparseSign.mat'];
load(filename);
SparseSignError=errList;




filename=[decay,'_',num2str(decayRate),'_single_fp_Rademacher.mat'];
loadData=load(filename);
RademacherError=loadData.errList;

if ~exist('Tlist','var')
    load('lowrank_0.0001_half_Add_fp.mat','Tlist');
end
filenamesplit=split(filename,"_");
decay=filenamesplit(1);
order=str2double(filenamesplit(2));
alpha=2*order;
n=1000;r=10;epsilon=0.05;
iterlist=[1,2,3,0];
pointSetX=zeros(1,numel(Tlist));
pointSetY=zeros(numel(iterlist),numel(Tlist));
ZGaussian=zeros(numel(iterlist),numel(Tlist));
pointSetYTYUCYinCW0=zeros(4,numel(Tlist));
ZRademacher=zeros(4,numel(Tlist));
pointSetYTYUCYinCW1=zeros(4,numel(Tlist));
ZCountSketch=zeros(4,numel(Tlist));
pointSetYSparseSign=zeros(4,numel(Tlist));
ZSparseSign=zeros(4,numel(Tlist));
pointSetYStreaming=zeros(4,numel(Tlist));
ZSparseRademacher=zeros(4,numel(Tlist));
xi=zeros(4,numel(Tlist));
xestimateList=[];
for iterT=1:numel(Tlist)
    T=Tlist(iterT);l=T;
    for iterq=1:numel(iterlist)
         pointSetX(iterq,iterT)=T;
        if iterlist(iterq)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iterq,iterT)=xestimate;
            pointSetZ(iterq,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        errList1=GaussianError(iterT,iterq,:,:);
        errList1 = squeeze(errList1); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList1(errList1 == 0) = Inf;
    

        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList1(:));
        [row, col] = ind2sub(size(errList1), linearIndex);
        s=min(row,col);
        
   
    pointSetY(iterq,iterT)=s;
    ZGaussian(iterq,iterT)=minValue;
        end
    end

    for iter=1:4
        if iterlist(iter)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iter,iterT)=xestimate;
            pointSetZ(iter,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        errList2=CountSketchError (iterT,iter,:,:);
        errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList2(errList2 == 0) = Inf;
        errList2(floor(T/2):end,:)=Inf;
        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList2(:));
        [row, col] = ind2sub(size(errList2), linearIndex);
        s1=min(row,col);
        
   
    pointSetYTYUCYinCW0 (iter,iterT)=s1;
    ZCountSketch(iter,iterT)=minValue;
        end
    end

    for iter=1:4
        if iterlist(iter)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iter,iterT)=xestimate;
            pointSetZ(iter,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        errList2=SparseRademacherError (iterT,iter,:,:);
        errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList2(errList2 == 0) = Inf;
        errList2(floor(T/2):end,:)=Inf;
        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList2(:));
        [row, col] = ind2sub(size(errList2), linearIndex);
        s1=min(row,col);
        
   
    pointSetYTYUCYinCW1 (iter,iterT)=s1;
   ZSparseRademacher(iter,iterT)=minValue;
        end
    end

     for iter=1:4
        if iterlist(iter)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iter,iterT)=xestimate;
            pointSetZ(iter,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        errList2=SparseSignError (iterT,iter,:,:);
        errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList2(errList2 == 0) = Inf;
        errList2(floor(T/2):end,:)=Inf;
        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList2(:));
        [row, col] = ind2sub(size(errList2), linearIndex);
        s1=min(row,col);
        
   
    pointSetYSparseSign(iter,iterT)=s1;
   ZSparseSign(iter,iterT)=minValue;
        end
    end

    for iter=1:4
        if iterlist(iter)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iter,iterT)=xestimate;
            pointSetZ(iter,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        errList2=RademacherError(iterT,iter,:,:);
        errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList2(errList2 == 0) = Inf;
        errList2(floor(T/2):end,:)=Inf;
        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList2(:));
        [row, col] = ind2sub(size(errList2), linearIndex);
        s1=min(row,col);
        
   
    pointSetYStreaming(iter,iterT)=s1;
    ZRademacher(iter,iterT)=minValue;
        end
    end
   
end
ZMatrix=[ZGaussian(1,:);ZRademacher(1,:);ZCountSketch(1,:);ZSparseSign(1,:);ZSparseRademacher(1,:)];
fig=paintFunc(@semilogy,Tlist,ZMatrix,{'-','--',':', '-.','-'},'DisplayName',{'Gaussian','Rademacher','CountSketch','SparseSign','SparseRademacher'});
set(get(gca, 'XLabel'), 'String', 'Storage budget T:');
set(get(gca, 'YLabel'), 'String', 'Relative Frobenius error:');
xlim([32,150]);
% figure(1);
% paintFunc(@semilogy,Tlist,ZGaussian,{'- o'},'DisplayName',{'Gaussian q=1','Gaussian q=2','Gaussian q=3','Gaussian q=0'});
% hold on;
% figure(2);
% paintFunc(@semilogy,Tlist,ZCountSketch,{': s'},'DisplayName',{'CountSketch q=1 ','CountSketch q=2','CountSketch q=3 ','CountSketch q=0'});
% hold on;
% paintFunc(@semilogy,Tlist,ZSparseRademacher,{'- s'},'DisplayName',{'Sparse q=1 ','Sparse q=2','Sparse q=3 ','Sparse q=0'});
% hold on;
% paintFunc(@semilogy,Tlist,ZRademacher,{'-- o'},'DisplayName',{'Rademacher q=1 ','Rademacher q=2','Rademacher q=3 ','Rademacher q=0'});
% title(['decayRate:',num2str(order),'decay',decay]);
% figure(2);
% paintFunc(@plot,Tlist,pointSetY,{'- o'},{'q=1','q=2','q=3','q=0','single-d*2','double-d*2','estimate'});
% title(['decayRate:',num2str(order),'decay',decay]);