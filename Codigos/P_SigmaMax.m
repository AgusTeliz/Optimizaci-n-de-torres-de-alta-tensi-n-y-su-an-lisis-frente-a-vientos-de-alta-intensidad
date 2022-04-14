%%%   Sigma Maximo   %%%
%%%   P_SigmaMax   %%%

SigmaMax = zeros(NumElementos*NumEstCarga,1);%*NumEstCarga

for j = 1 : NumEstCarga
    for i = 1 : NumElementos
        SigmaMax(i+(j-1)*NumElementos) = MatMateriales(MatElementos(i,4),8);
    
    end
end
