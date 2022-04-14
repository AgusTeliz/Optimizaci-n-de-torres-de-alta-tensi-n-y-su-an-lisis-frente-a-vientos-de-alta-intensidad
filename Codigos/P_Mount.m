P_SigmaMax 

P_MountVF;

K = F_MountMK(X0);


P_MountMM

%%
Factor06 = 0;

if Factor06 == 0
    %% NO se considera el factor 0.6 para la fuerza del cable como fuerza de masa

    VecF(3:3:end,:) = 0;

    D_m = diag(M)*3/2;

    D_m = -D_m*9.8/1000; % Fuerza en kN
    DD_F = D_m(3:3:end);

    DD_c = zeros(size(DD_F));
    DD_c([77-4  78-4  111-4 112-4 157-4 158-4 183-4 184-4]) = Dc;% Para sacar la fuerza de los cables

    VecF(3:3:end,:) = [DD_F+DD_c DD_F+DD_c 0.6*DD_F+DD_c DD_F+DD_c DD_F+DD_c 0.6*DD_F+DD_c DD_F+DD_c];
else
    %% Se considera el factor 0.6 para la fuerza del cable como fuerza de masa
    VecF(3:3:end,:) = 0;

    D_m =  diag(M)*3/2;
    D_m = -D_m*9.8/1000; % Fuerza en kN
    D_m = D_m(3:3:end);
    

    Nod_Cables = [77-4  78-4  111-4 112-4 157-4 158-4 183-4 184-4];
    D_m(Nod_Cables) = D_m(Nod_Cables)+Dc;

    VecF(3:3:end,:) =[D_m D_m 0.6*D_m D_m D_m 0.6*D_m D_m];
end

%%
% dlmwrite('Fuerza_Z.txt',VecF(3:3:end,1))

VecU = F_MountVecU(K);

Sigma = F_MountSigma(X0,VecU);