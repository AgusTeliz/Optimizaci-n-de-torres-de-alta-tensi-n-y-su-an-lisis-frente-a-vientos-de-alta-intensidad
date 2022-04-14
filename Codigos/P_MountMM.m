%-----------   P_MountMK   ------------------------------
%------------------------------------------------------------


MatM = MatK*0;
MatMe0 = zeros(6);
    MatMe0(1,1) = 2;
    MatMe0(1,4) = 1;
    MatMe0(2,2) = 2;
    MatMe0(2,5) = 1;
    MatMe0(3,3) = 2;
    MatMe0(3,6) = 1;
    MatMe0(4,4) = 2;
    MatMe0(5,5) = 2;
    MatMe0(6,6) = 2;

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
    
    LL = 1000 * sqrt(DX*DX + DY*DY + DZ*DZ); % Para pasar a mm

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  Propiedades geométricas del elemento y propiedades del material %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    VarS = MatElementos(Elem,VS);
    Mate = MatElementos(Elem,Ma);
    
    Aele = MatVarSecR(VarS,Ax);
    Dele = MatMaterialesR(Mate,3);
    
    DAxL = Dele*Aele*LL;

    MatMe = MatMe0*(DAxL/6);

    
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
            MatM(NZA) = MatM(NZA) + MatMe(GrLN1(Ind1),GrLN1(Ind2));
            NZA = NZA + 1;
        end
    end
    
    % Nodo 2
    NZA = MatElemAux(Elem,2);
    for Ind1 = 1:NGLN2
        for Ind2 = Ind1:NGLN2
            MatM(NZA) = MatM(NZA) + MatMe(GrLN2(Ind1),GrLN2(Ind2));
            NZA = NZA + 1;
        end
    end
    
    % Nodo 1-2
    NZA = MatElemAux(Elem,3);
    for Ind1 = 1:NGLN1
        for Ind2 = 1:NGLN2
            MatM(NZA) = MatMe(GrLN1(Ind1),GrLN2(Ind2));
            NZA = NZA + 1;
        end
    end
end

MatMM = sparse(IRN,ICN,MatM);
Diag = diag(MatMM);
MatMM = MatMM + MatMM' - diag(Diag);
M = full(MatMM);


