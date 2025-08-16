for T=40:20:320
    for r=5:5:10
        T
        r
        [errF,errS]=testError(imageMatrix20000,T,r,1e-4);
    end
end