function [ g, geq, dg, dgeq ] = F_Restricciones(X)

    global SigmaMax NumEstCarga NumGrLib NumResCol NumElementos;
    global NumVar 
    K = F_MountMK(X);
    
    U = F_MountVecU(K);

    Sigma = F_MountSigma(X,U);

    Sigma = Sigma(:);
    
    SigPand = F_SigmaPandeo(X);
    DSigPand = F_DSigmaPandeo(X);
    
    SigmaPandeo = zeros(NumElementos*NumEstCarga,1);
    DSigmaPandeo = zeros(NumElementos*NumEstCarga,NumVar);
    for i = 1:NumEstCarga
        SigmaPandeo(NumElementos*(i-1)+1:NumElementos*i) = SigPand;
        DSigmaPandeo(NumElementos*(i-1)+1:NumElementos*i,:) = DSigPand;
    end
        
    g =  [Sigma-SigmaMax; -Sigma-SigmaMax ; SigmaPandeo - Sigma];


    geq = F_MountCol(X);

    if (nargout>2)
        DKVU = F_MountDKVU(X,U);

        % Calculo DU
        DU = zeros(size(DKVU));

        Pos = 0;
        for Est = 1 : NumEstCarga
            DU(Pos+1:Pos+NumGrLib,:) = K\(-DKVU(Pos+1:Pos+NumGrLib,:));
            Pos = Pos+NumGrLib;
        end

        DSigma =  F_MountDSigma(X,U,DU);
        dg = [DSigma; -DSigma; DSigmaPandeo - DSigma];

        dgeq = F_MountDCol(X);
        dgeq = dgeq(:,1:end-NumResCol);

        dg = dg';
        dgeq = dgeq';
    end
end
