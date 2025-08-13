% filename="poly_1_single_fp3m400n2000.mat";c=0.2;
filename="exp_0.5_TYUC17SPIStandard";
load(strcat(filename,".mat"));
% if ~exist('Tlist','var')
%     load('lowrank_0.0001_half_Add_fp.mat','Tlist');
% end
filenamesplit=split(filename,"_");
decay=filenamesplit(1);
decayRate=str2double(filenamesplit(2));
m=1000;n=1000;
c=m/n;r=10;epsilon=0.05;
iterlist=[1,2,3,0];
pointSetX=zeros(1,numel(Tlist));
pointSetY=zeros(4,numel(Tlist));
pointSetZ=zeros(5,numel(Tlist));
xi=zeros(4,numel(Tlist));
xestimateList=[];
for iterT=1:numel(Tlist)
    T=Tlist(iterT);l=T;
    for iterq=1:numel(iterlist)
        errList1=errList(iterT,iterq,:,:);
        errList1 = squeeze(errList1); % Convert to 61x61 matrix if necessary

    % Set zero elements to Inf to exclude them from the minimum search
    errList1(errList1 == 0) = Inf;

    % Find the minimum value and its position
    [minValue, linearIndex] = min(errList1(:));
    [row, col] = ind2sub(size(errList1), linearIndex);
    s=min(row,col);
    pointSetX(iterq,iterT)=T;
    pointSetY(iterq,iterT)=s;
    pointSetZ(iterq,iterT)=minValue;
    end
    xestimate=ParameterGuide(n,T,r,decay,decayRate,c);
    xestimate=floor(xestimate);
    % xestimate=r;
    % Cpara=1;
    % para=Cpara*(alpha-1)/((2*alpha));
    % xestimate=floor(min(max(r,para*(2*T-1)),T/2-1));
    xestimateList(end+1)=xestimate;
    pointSetZ(5,iterT)=max(errList(iterT,1,xestimate,:));
end
 pointSetY(5,:)=xestimateList;
figure(1);
paintFunc(@plot,Tlist,pointSetY,{'- o'},'DisplayName',{'q=1','q=2','q=3','q=0','estimate'});
figure(2);
paintFunc(@semilogy,Tlist,pointSetZ,{'- o'},'DisplayName',{'q=1','q=2','q=3','q=0','estimate'});
title(['decay:',decay,'decayRate:',num2str(decayRate)]);