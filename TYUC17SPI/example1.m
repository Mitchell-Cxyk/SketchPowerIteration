changeCurrentFolderToScriptFolder;
decay='poly';
decayRateList=[0.5,1,2];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testTYUC17SPIm1000n1000(decay,decayRateList(iter));
end
decay='exp';
decayRateList=[0.01,0.1,0.5];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testTYUC17SPIm1000n1000(decay,decayRateList(iter));
end
decay='lowrank';
decayRateList=[0.0001,0.01,0.1];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testTYUC17SPIm1000n1000(decay,decayRateList(iter));
end
