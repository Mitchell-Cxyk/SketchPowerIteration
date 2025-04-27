function s=TYUC17ParamenterGuide(n,T,r,decay,decayRate)
% T: the storage size
% n: the size of the matrix
% decay: the decay type: 'exp', 'lowrank', 'poly'
% decayRate: the decay rate
% s: the parameter suggested by the guide
epsilon=0.01;
decay=lower(decay);
% T=T*2;
if strcmp(decay,'lowrank')
    if decayRate>0.05
    T=T/2;
    end
   s=max(r+2,floor((T-1)*((sqrt(r*(T-r-2)*(1-2/(T-1)))-(r-1))/(T-2*r-1))));
elseif strcmp(decay,'exp')
    if decayRate<0.05
        T=T/2;
        s=max(r+2,floor((T-1)*((sqrt(r*(T-r-2)*(1-2/(T-1)))-(r-1))/(T-2*r-1))));
    else
   s=max(r,floor((T-2)/2));
    end
elseif strcmp(decay,'poly')
    s=max(r+2,floor((T-2)/3));
else
    error('Unknown decay type');
end