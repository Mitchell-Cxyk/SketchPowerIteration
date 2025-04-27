decay='exp';
% decayRateList=[0.01,0.05,0.1,0.5,0.8,1,1.5,2];
decayRateList=[0.01,0.1,0.5];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testFixedStreaming(decay,decayRate);
end
decay='lowrank';
% decayRateList=[1e-4,1e-3,1e-2,5e-2,1e-1,3e-1,5e-1];
decayRateList=[1e-4,1e-2,1e-1];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testFixedStreaming(decay,decayRate);
end
decay='poly';
% decayRateList=[0.01,0.1,0.3,0.9,1.1,1.3,1.8,2.5];
% decayRateList=[decayRateList,0.35,0.45,0.55,0.65,0.75];
% decayRateList=[decayRateList,0.5,2];
decayRateList=[0.5,1,2];
for iter=1:numel(decayRateList)
    decay
    decayRate=decayRateList(iter)
    testFixedStreaming(decay,decayRate);
end