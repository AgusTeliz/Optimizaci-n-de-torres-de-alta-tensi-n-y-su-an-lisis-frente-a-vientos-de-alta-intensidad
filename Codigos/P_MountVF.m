%-----------     P_MountVF    ------------------------------
%------------------------------------------------------------

VecF = zeros(NumGrLib,NumEstCarga);

for NodG = 1:NumNodos
    GrGN = MatGrLib(NodG,DG1:DG3);
    NGLN = MatGrLib(NodG,NDL);
    GrLN = MatGrLib(NodG,DL1:DL3);
    
    for Est = 1:NumEstCarga
        for GrL = 1:NGLN
            VecF(GrGN(GrLN(GrL)),Est) = VecF(GrGN(GrLN(GrL)),Est) + MatFo(NodG,GrLN(GrL),Est);
        end
    end
end
