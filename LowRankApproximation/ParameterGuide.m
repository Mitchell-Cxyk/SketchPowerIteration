function s=ParameterGuide(n,T,r,decay,decayRate,varargin)
% T: the storage size, actually this T is the T used in TYUC17; here as we
% use single-preicision sketches, we need to set T = T*2 in the beginning.
% n: the size of the matrix
% decay: the decay type: 'exp', 'lowrank', 'poly'
% decayRate: the decay rate
% c: m/n
% s: the parameter suggested by the guide
epsilon=0.01;c=1;
if numel(varargin)>=1
    c=varargin{1};
end
decay=lower(decay);
T=T*2;          % represent single-precision sketches; the sizes can be doubled.
if strcmp(decay,'lowrank')
   s=r;

elseif strcmp(decay,'exp')
    temp=decayRate*log(10);
    core=(T/2/(c+1))-1/(2*temp);
    if r>T/2/(1+c)||decayRate<=0.01
        s=r;
    else
    s=floor(min(max(r,core),T/2/(c+1)))
    end


    % if temp<3/T
    % if temp<1/(T/2-2*r)
    % s=r;
    % elseif temp>1/()
    % 
    %     % s=(T/2-6*r)/4+r;
    % 
    %     % s=(T-3/temp)/4;
    % 
    %     % s=floor(T/(2*(c+1)));
    %     % s=max(s,r);
    % 
    %     % s=T/4-2;
    % end
elseif strcmp(decay,'poly')
    if decayRate<1/2-epsilon
        s=r;
    elseif decayRate>1/2+epsilon
        s=max(r, ((2*decayRate - 1)*(T/2 + 1) - (c + 1)) / (2*(c + 1)*decayRate));
    else
        xx=-((T+2*c)/(1*(c+1)))/(lambertw(-1,-(T+2*c)/(2*(c+1)*n*exp(1))))-1;
        s=min(max(xx,r),T/4);
    end
else
    error('Unknown decay type');
end
end