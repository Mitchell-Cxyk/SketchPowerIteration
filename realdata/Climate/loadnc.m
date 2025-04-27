filePath='../../dataset/surface';
files=dir(filePath);
FileName={files.name};
slpFileName=FileName(contains(FileName,'slp'));
dataMatrix=zeros(144*73,366);
label=0;
for iter=1:numel(slpFileName)
    filename=fullfile(filePath,slpFileName{iter});
    Origindata=ncread(filename,'slp');
    [m,n,d]=size(Origindata);
    dataMatrix(:,label+1:label+d)=reshape(Origindata,144*73,d);
    label=label+d;
end
save('dataMatrix.mat','dataMatrix','-v7.3');
