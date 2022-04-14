%% P_PerfilesNormalizados

X1 = zeros(size(MatVarSec,1),1);

    for i = 1 : size(MatVarSec,1)

        
        Num_perfil = find(Area >= X0(i));
        
        X1(i) = min(Area(Num_perfil));
        
        
        
    end
    
%% Pasar a perfiles normalizados

Prf_Norm = 1;

if Prf_Norm == 1
    X0(1:5) = X1(1:5);
end
MatVarSecR(1:5,1) = X0(1:5);

        