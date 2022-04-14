%-----------   P_MountMG   ------------------------------
%------------------------------------------------------------

MatG=MatK*0;
MatGe0 = zeros(6);
    MatGe0(1,1) =  1;
    MatGe0(1,4) = -1;
    MatGe0(2,2) =  1;
    MatGe0(2,5) = -1;
    MatGe0(3,3) =  1;
    MatGe0(3,6) = -1;
    MatGe0(4,4) =  1;
    MatGe0(5,5) =  1;
    MatGe0(6,6) =  1;

    

    


    
VecSigma = F_Sigma([MatVarSecR(1:NumVarSec,1) ; MatVarPosR(1:NumVarPos,1)]);
VecSigma = VecSigma((Ensayo-1)*NumElementos+1:Ensayo*NumElementos);

for Elem = 1:NumElementos
    
    %************************************************************************************
    % Matriz elemento -------------------------------------------------------------------
    
    Nod1 = MatElementos(Elem,N1); % Se supone que Nod1 < Nod2 (Ver: Cambio orden en Lectura)
    Nod2 = MatElementos(Elem,N2);
    
    Sis1 = MatNodos(Nod1,Si);
    Sis2 = MatNodos(Nod2,Si);
    
    Co1X = MatSisCoord(Sis1,XX);
    Co1Y = MatSisCoord(Sis1,YY);
    Co1Z = MatSisCoord(Sis1,ZZ);
    Co2X = MatSisCoord(Sis2,XX);
    Co2Y = MatSisCoord(Sis2,YY);
    Co2Z = MatSisCoord(Sis2,ZZ);
    
    Var1X = MatNodos(Nod1,VX);
    Var1Y = MatNodos(Nod1,VY);
    Var1Z = MatNodos(Nod1,VZ);
    Var2X = MatNodos(Nod2,VX);
    Var2Y = MatNodos(Nod2,VY);
    Var2Z = MatNodos(Nod2,VZ);
    
    X1 = Co1X*MatVarPosR(Var1X,Co);
    Y1 = Co1Y*MatVarPosR(Var1Y,Co);
    Z1 = Co1Z*MatVarPosR(Var1Z,Co);
    X2 = Co2X*MatVarPosR(Var2X,Co);
    Y2 = Co2Y*MatVarPosR(Var2Y,Co);
    Z2 = Co2Z*MatVarPosR(Var2Z,Co);
    
    DX = X2 - X1;
    DY = Y2 - Y1;
    DZ = Z2 - Z1;
    
    LL = sqrt(DX*DX + DY*DY + DZ*DZ);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  Propiedades geométricas del elemento y propiedades del material %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Sigmae = VecSigma(Elem);
    
    VarS = MatElementos(Elem,VS);
    Mate = MatElementos(Elem,Ma);
    
    Aele = MatVarSecR(VarS,Ax);
    Dele = MatMaterialesR(Mate,3);
    
    MatGe = Sigmae*Aele/LL*MatGe0;

    
    %************************************************************************************
    % Monto vectores GrLE y UeGE ------------------------------------------------------
    
    NodL = N1;
    NodG = MatElementos(Elem,NodL);
    NGLN1 = MatGrLib(NodG,NDL);
    GrLN1 = MatGrLib(NodG,DL1:DL3);
    
    NodL = N2;
    NodG = MatElementos(Elem,NodL);
    NGLN2 = MatGrLib(NodG,NDL);
    GrLN2 = MatGrLib(NodG,DL1:DL3) + NGN;
    
    %************************************************************************************
    % Monto matrices MatK y MatR, y vectores VecF y VecR --------------------------------
    
    % Nodo 1
    NZA = MatElemAux(Elem,1);
    for Ind1 = 1:NGLN1
        for Ind2 = Ind1:NGLN1
            MatG(NZA) = MatG(NZA) + MatGe(GrLN1(Ind1),GrLN1(Ind2));
            NZA = NZA + 1;
        end
    end
    
    % Nodo 2
    NZA = MatElemAux(Elem,2);
    for Ind1 = 1:NGLN2
        for Ind2 = Ind1:NGLN2
            MatG(NZA) = MatG(NZA) + MatGe(GrLN2(Ind1),GrLN2(Ind2));
            NZA = NZA + 1;
        end
    end
    
    % Nodo 1-2
    NZA = MatElemAux(Elem,3);
    for Ind1 = 1:NGLN1
        for Ind2 = 1:NGLN2
            MatG(NZA) = MatGe(GrLN1(Ind1),GrLN2(Ind2));
            NZA = NZA + 1;
        end
    end
end

MatGG = sparse(IRN,ICN,MatG);
DiagGG = diag(MatGG);
MatGG = MatGG + MatGG' - diag(DiagGG);
G = full(MatGG);
