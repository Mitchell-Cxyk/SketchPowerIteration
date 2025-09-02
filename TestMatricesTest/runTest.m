decayList={{'lowrank',0.0001,0.01,0.1},{'poly',0.5,1,2},{'exp',0.01,0.1,0.5}};
% distributionList={'Gaussian','Rademacher','CountSketch','SparseRademacher','SparseSign'};
distributionList={'SparseRademacher01'};
for distributionIter=1:length(distributionList)
    distribution=distributionList{distributionIter}
    for iter1=1:numel(decayList)
        decay=decayList{iter1}{1};
        for iter2=2:numel(decayList{iter1})
            decayRate=decayList{iter1}{iter2};
            testFixedPrecisionWithDifferentDistribution(decay,decayRate,distribution)
        end
    end
end
