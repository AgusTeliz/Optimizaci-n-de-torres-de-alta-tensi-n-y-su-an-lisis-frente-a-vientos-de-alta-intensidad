%-------------------  F_MountVecU(K) --------------------------
%--------------------------------------------------------------

function [VecU] = F_MountVecU(K)

    global VecF

    VecU = K\VecF;
    VecU = VecU(:);
end