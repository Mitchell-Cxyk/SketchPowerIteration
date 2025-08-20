for T=30:20:290
    for r=5:5:10
        T
        r
        [errF,errS]=testClimateError(dataMatrix,T,r,1e-4);
    end
end