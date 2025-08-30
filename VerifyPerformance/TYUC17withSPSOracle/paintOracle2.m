function fout=paintOracle2(decay,decayRate)
if strcmpi(decay,'exp')&& decayRate>0.05
    filename=[decay,'_',num2str(decayRate),'_TYUC17SPIStandard.mat'];
else
    filename=[decay,'_',num2str(decayRate),'_TYUC17SPIStandard.mat'];
end
loadData=load(filename);
ErrList=loadData.errListSpec;
Tlist=loadData.Tlist;
errList=ErrList;
% filename=[decay,'_',num2str(decayRate),'_fixedW1_YinC_fp.mat'];
% load(filename);
% TYUCYINCerrListW1=errList;
% 
% filename=[decay,'_',num2str(decayRate),'_fixedW0_YinC_fp.mat'];
% load(filename);
% TYUCYINCerrListW0=errList;



% filename=[decay,'_',num2str(decayRate),'_streaming_fp.mat'];
% loadData=load(filename);
% StreamingErrList=loadData.errList;

% if ~exist('Tlist','var')
%     load('lowrank_0.0001_half_Add_fp.mat','Tlist');
% end
filenamesplit=split(filename,"_");
decay=filenamesplit(1);
order=str2double(filenamesplit(2));
alpha=2*order;
n=1000;r=10;epsilon=0.05;
iterlist=[1,2,3,0,-1,-2];
pointSetX=zeros(1,numel(Tlist));
pointSetY=zeros(numel(iterlist),numel(Tlist));
pointSetZ=zeros(numel(iterlist),numel(Tlist));
pointSetYTYUCYinCW0=zeros(4,numel(Tlist));
pointSetZTYUCYinCW0=zeros(4,numel(Tlist));
pointSetYTYUCYinCW1=zeros(4,numel(Tlist));
pointSetZTYUCYinCW1=zeros(4,numel(Tlist));
% pointSetYStreaming=zeros(4,numel(Tlist));
% pointSetZStreaming=zeros(4,numel(Tlist));
xi=zeros(4,numel(Tlist));
xestimateList=[];
for iterT=1:numel(Tlist)
    T=Tlist(iterT);l=T;
    for iterq=1:numel(iterlist)
         pointSetX(iterq,iterT)=T;
        if iterlist(iterq)==-1
            if strcmpi(decay,'poly')&& decayRate==0.5
                xestimate=ParameterGuide(n,T,r,decay,decayRate);
            elseif strcmpi(decay,'lowrank') && decayRate==0.1
                xestimate=TYUC17ParamenterGuide(n,T,r,decay,decayRate);
            else
             xestimate=ParameterGuide(n,T,r,decay,decayRate);
             end
            % iterq,iterT
            pointSetY(iterq,iterT)=xestimate;
            pointSetZ(iterq,iterT)=max(errList(iterT,1,round(xestimate),:));
        elseif iterlist(iterq)==-2
             xestimate=TYUC17ParamenterGuide(n,T,r,decay,decayRate);
            % iterq,iterT
            pointSetY(iterq,iterT)=xestimate;
            pointSetZ(iterq,iterT)=max(errList(iterT,4,round(xestimate),:));
        else
        errList1=errList(iterT,iterq,:,:);
        errList1 = squeeze(errList1); 

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

    % for iter=1:4
    %     if iterlist(iter)<0
    %         xestimate=ParameterGuide(n,T,r,decay,decayRate);
    %         % iterq,iterT
    %         pointSetY(iter,iterT)=xestimate;
    %         pointSetZ(iter,iterT)=max(errList1(iterT,1,round(xestimate),:));
    %     else
    %     errList2=TYUCYINCerrListW0 (iterT,iter,:,:);
    %     errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary
    % 
    %     % Set zero elements to Inf to exclude them from the minimum search
    %     errList2(errList2 == 0) = Inf;
    %     errList2(round(T/2):end,:)=Inf;
    %     % Find the minimum value and its position
    %     [minValue, linearIndex] = min(errList2(:));
    %     [row, col] = ind2sub(size(errList2), linearIndex);
    %     s1=min(row,col);
    % 
    % 
    % pointSetYTYUCYinCW0 (iter,iterT)=s1;
    % pointSetZTYUCYinCW0(iter,iterT)=minValue;
    %     end
    % end
    % 
    % for iter=1:4
    %     if iterlist(iter)<0
    %         xestimate=ParameterGuide(n,T,r,decay,decayRate);
    %         % iterq,iterT
    %         pointSetY(iter,iterT)=xestimate;
    %         pointSetZ(iter,iterT)=max(errList(iterT,1,round(xestimate),:));
    %     else
    %     errList2=TYUCYINCerrListW1 (iterT,iter,:,:);
    %     errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary
    % 
    %     % Set zero elements to Inf to exclude them from the minimum search
    %     errList2(errList2 == 0) = Inf;
    %     errList2(round(T/2):end,:)=Inf;
    %     % Find the minimum value and its position
    %     [minValue, linearIndex] = min(errList2(:));
    %     [row, col] = ind2sub(size(errList2), linearIndex);
    %     s1=min(row,col);
    % 
    % 
    % pointSetYTYUCYinCW1 (iter,iterT)=s1;
    % pointSetZTYUCYinCW1(iter,iterT)=minValue;
    %     end
    % end
    % 
    % for iter=1:4
    %     if iterlist(iter)<0
    %         xestimate=ParameterGuide(n,T,r,decay,decayRate);
    %         % iterq,iterT
    %         pointSetY(iter,iterT)=xestimate;
    %         pointSetZ(iter,iterT)=max(errList(iterT,1,round(xestimate),:));
    %     else
    %     errList2=StreamingErrList(iterT,iter,:,:);
    %     errList2 = squeeze(errList2); % Convert to 61x61 matrix if necessary
    % 
    %     % Set zero elements to Inf to exclude them from the minimum search
    %     errList2(errList2 == 0) = Inf;
    %     errList2(round(T/2):end,:)=Inf;
    %     % Find the minimum value and its position
    %     [minValue, linearIndex] = min(errList2(:));
    %     [row, col] = ind2sub(size(errList2), linearIndex);
    %     s1=min(row,col);
    % 
    % 
    % pointSetYStreaming(iter,iterT)=s1;
    % pointSetZStreaming(iter,iterT)=minValue;
    %     end
    % end
    % syms x;
    % if abs(alpha-1)>epsilon
    % f=2*n^(1-alpha)-2*alpha*x^(1-alpha)-l*(1-alpha)*x^(-alpha);
    % xestimate=vpasolve(f==0,x,[r,round(l/2)]);
    % if isempty(xestimate)
    %     if subs(f,x,r)>0
    %         xestimate=r;
    %     else
    %         xestimate=round(l/2);
    %     end
    % end
    % end
    % if abs(alpha-1)<epsilon
    % xestimate=(-T)/(2*lambertw(-1,-T/(2*n*lowrank(1))))-1; xestimate = real(xestimate);
    %     if xestimate<r
    %         xestimate=r;
    %     elseif xestimate>round(l/2)
    %         xestimate=round(l/2);
    %     end
    % end
    % xestimate=round(xestimate);
    % Cpara=1;
    % para=Cpara*(alpha-1)/((2*alpha));
    % xestimate=round(min(max(r,para*(2*T-1)),T/2-1));
    % xestimateList(end+1)=xestimate;
    % pointSetZ(5,iterT)=errList(iterT,1,xestimate,l-xestimate);
end
paintFunc(@semilogy,Tlist,pointSetZ,{'--','--','--','-.','o','diamond'},'DisplayName',{'SPI q=1','SPI q=2','SPI q=3','TYUC17','SPI-estimate','TYUC17-Estimate'},'LineWidthList',{3.5,3,2.5,2.5,3,3},'ColorOrder',[1,2,3,4,5,6]);
fout=gcf;
% xlim([60,150]);
% ylim([1e-2,1e1]);
% hold on;
% paintFunc(@semilogy,Tlist,pointSetZTYUCYinCW0,{': o'},{'q=1 W0 ','q=2 W0','q=3 W0','q=0 W0'});
% hold on;
% paintFunc(@semilogy,Tlist,pointSetZTYUCYinCW1,{'- s'},{'q=1 W1 ','q=2 W1','q=3 W1','q=0 W1'});
% hold on;
% paintFunc(@semilogy,Tlist,pointSetZStreaming,{'-- o'},{'q=1 Streaming','q=2 Streaming','q=3 Streaming','q=0 Streaming'});
% title(['decayRate:',num2str(order),'decay',decay]);
% figure(2);
% paintFunc(@plot,Tlist,pointSetY,{'- o'},{'q=1','q=2','q=3','q=0','SPS-estimate','TYUC17-estimate'},{3.5,3,2.5,2.5,3,3});
% title(['decayRate:',num2str(order),'decay',decay]);
end