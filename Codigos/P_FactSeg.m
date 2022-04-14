%%%   P_FS   %%%
    
    SigPand = F_SigmaPandeo(X0);
    DSigPand = F_DSigmaPandeo(X0);
    
    SigmaPandeo = zeros(NumElementos*NumEstCarga,1);
    DSigmaPandeo = zeros(NumElementos*NumEstCarga,NumVar);
    for i = 1:NumEstCarga
        SigmaPandeo(NumElementos*(i-1)+1:NumElementos*i) = SigPand;
    end
        
    FS =  [SigmaMax./Sigma; SigmaMax./(-Sigma) ; SigmaPandeo./Sigma];

    for i = 1 : length(FS)
        if FS(i) < 0
            FS(i) = inf;
        end
    end
    FS_T = min(FS)
    