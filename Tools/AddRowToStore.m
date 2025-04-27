function output=AddRowToStore(varargin)
%The first input is StoreMatrix, the second is row.
if length(varargin)>=1
    Store=varargin{1};
end
if length(varargin)>=2
    row=varargin{2};
end
Storelength=size(Store,2);
rowlength=length(row);
if Storelength==0
    output=row;
else
    if Storelength<rowlength
        Store=[Store,zeros(size(Store,1),rowlength-Storelength)];
    else
        row=[row,zeros(1,Storelength-rowlength)];
    end
    output=[Store;row];
end
end