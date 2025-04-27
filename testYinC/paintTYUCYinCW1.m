function gf=paintTYUCYinCW1(decay,decayRate)
% decay='lowrank';decayRate=0.1;
% filename=[decay,'_',num2str(decayRate),'_fixedW0_fp5.mat'];
TlistStore=[];
filename=[decay,'_',num2str(decayRate),'_TYUC17SPIStandard.mat'];
load(strcat('data/',filename));
ErrList=errList;
TlistStore=AddRowToStore(TlistStore,Tlist);
filenamesplit=split(filename,"_");
decay=filenamesplit{1};
order=str2double(filenamesplit{2});
alpha=2*order;
n=1000;r=10;epsilon=0.05;
iterlist=[1,2,3,0];
pointSetX=zeros(1,numel(Tlist));
pointSetY=zeros(numel(iterlist),numel(Tlist));
pointSetZ=zeros(numel(iterlist),numel(Tlist));
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
            pointSetZ(iterq,iterT)=max(ErrList(iterT,1,floor(xestimate),:));
        else
        errList1=ErrList(iterT,iterq,:,:);
        errList1 = squeeze(errList1); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList1(errList1 == 0) = Inf;
    

        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList1(:));
        [row, col] = ind2sub(size(errList1), linearIndex);
        s=min(row,col);
        
   
    pointSetY(iterq,iterT)=s;
    pointSetZ(iterq,iterT)=minValue;
        end
    end
end

    filename=[decay,'_',num2str(decayRate),'_fixedW1_YinC_fp5.mat'];
    load(strcat('data/',filename));
    TYUCYINCerrListW1=errList;
    TlistStore=AddRowToStore(TlistStore,Tlist);
    TlistStore=AddRowToStore(TlistStore,Tlist);
    TlistStore=AddRowToStore(TlistStore,Tlist);
    TlistStore=AddRowToStore(TlistStore,Tlist);
    pointSetYTYUCYinCW1=zeros(4,numel(Tlist));
    pointSetZTYUCYinCW1=zeros(4,numel(Tlist));
    for iterT=1:numel(Tlist)
    for iter=1:4
        if iterlist(iter)<0
            xestimate=ParameterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iter,iterT)=xestimate;
            pointSetZ(iter,iterT)=max(errList(iterT,1,floor(xestimate),:));
        else
        if iterT>size(TYUCYINCerrListW1,1)
            temp=size(TYUCYINCerrListW1,1);
        else 
            temp=iterT;
        end
        errList2=TYUCYINCerrListW1 (temp,iter,:,:);
        errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary

        % Set zero elements to Inf to exclude them from the minimum search
        errList2(errList2 == 0) = Inf;
        errList2(floor(T/2):end,:)=Inf;
        % Find the minimum value and its position
        [minValue, linearIndex] = min(errList2(:));
        [row, col] = ind2sub(size(errList2), linearIndex);
        s1=min(row,col);
        
   
    pointSetYTYUCYinCW1 (iter,iterT)=s1;
    pointSetZTYUCYinCW1(iter,iterT)=minValue;
        end
    end
    end

   

figure(1);
paintFunc(@semilogy,TlistStore(1,:),pointSetZ(4,:),{'-'},'DisplayName',{'TYUC17-double'});
hold on;
% figure(2);
paintFunc(@semilogy,TlistStore(2:end,:),pointSetZTYUCYinCW1,{'--'},'DisplayName',{'variant of SPI q=1','variant of SPI q=2','variant of SPI q=3','TYUC17-single'});
% hold on;
% paintFunc(@semilogy,Tlist,pointSetZTYUCYinCW1,{'- s'},'DisplayName',{'q=1 W1 ','q=2 W1','q=3 W1','q=0 W1'});
% hold on;
% paintFunc(@semilogy,Tlist,pointSetZStreaming,{'-- o'},'DisplayName',{'q=1 Streaming','q=2 Streaming','q=3 Streaming','q=0 Streaming'});
% title(['decayRate:',num2str(order),'decay',decay]);
% figure(2);
% paintFunc(@plot,Tlist,pointSetY,{'- o'},{'q=1','q=2','q=3','q=0','single-d*2','double-d*2','estimate'});
% title(['decayRate:',num2str(order),'decay',decay]);
end