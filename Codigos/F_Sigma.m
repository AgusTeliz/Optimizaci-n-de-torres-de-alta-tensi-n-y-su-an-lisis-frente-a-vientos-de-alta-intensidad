function [ Sigma ] = F_Sigma(X)

    K = F_MountMK(X);

    U = F_MountVecU(K);

    Sigma = F_MountSigma(X,U);

end
