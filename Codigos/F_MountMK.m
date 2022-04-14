%---------------------  F_MountMK(X) --------------------------
%--------------------------------------------------------------

function [K] = F_MountMK(X)

    global NumElementos N1 N2 Si XX YY ZZ VX VY VZ Co Ma EE CD1 NDL DL1 DL3 NGN   ;
    global VS  Ax NumVarPos  NumVarSec

    global MatElementos MatNodos MatSisCoord MatMaterialesR MatGrLib ;

    global MatElemAux MatVarPosR MatVarSecR

    global MatK IRN ICN

    MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
    MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

    K0=MatK*0;
    
    Ke = zeros(6);

    for Elem = 1 : NumElementos

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
        LI = CD1/LL;

        XL = LI*DX;
        YL = LI*DY;
        ZL = LI*DZ;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%  Propiedades geométricas del elemento y propiedades del material  %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        VarS = MatElementos(Elem,VS);
        Mate = MatElementos(Elem,Ma);

        Aele = MatVarSecR(VarS,Ax);
        Eele = MatMaterialesR(Mate,EE);

        EAxL = LI*Eele*Aele;

        Ke(1,1) = EAxL*(XL*XL);
        Ke(1,2) = EAxL*(XL*YL);
        Ke(1,3) = EAxL*(XL*ZL);
        Ke(1,4) = -Ke(1,1);
        Ke(1,5) = -Ke(1,2);
        Ke(1,6) = -Ke(1,3);
        Ke(2,2) = EAxL*(YL*YL);
        Ke(2,3) = EAxL*(YL*ZL);
        Ke(2,4) = -Ke(1,2);
        Ke(2,5) = -Ke(2,2);
        Ke(2,6) = -Ke(2,3);
        Ke(3,3) = EAxL*(ZL*ZL);
        Ke(3,4) = -Ke(1,3);
        Ke(3,5) = -Ke(2,3);
        Ke(3,6) = -Ke(3,3);
        Ke(4,4) = Ke(1,1);
        Ke(4,5) = Ke(1,2);
        Ke(4,6) = Ke(1,3);
        Ke(5,5) = Ke(2,2);
        Ke(5,6) = Ke(2,3);
        Ke(6,6) = Ke(3,3);

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
        % Monto matrices K0 y MatR, y vectores VecF y VecR --------------------------------

        % Nodo 1
        NZA = MatElemAux(Elem,1);
        for Ind1 = 1:NGLN1
            for Ind2 = Ind1:NGLN1
                K0(NZA) = K0(NZA) + Ke(GrLN1(Ind1),GrLN1(Ind2));
                NZA = NZA + 1;
            end
        end

        % Nodo 2
        NZA = MatElemAux(Elem,2);
        for Ind1 = 1:NGLN2
            for Ind2 = Ind1:NGLN2
                K0(NZA) = K0(NZA) + Ke(GrLN2(Ind1),GrLN2(Ind2));
                NZA = NZA + 1;
            end
        end

        % Nodo 1-2
        NZA = MatElemAux(Elem,3);
        for Ind1 = 1:NGLN1
            for Ind2 = 1:NGLN2
                K0(NZA) = Ke(GrLN1(Ind1),GrLN2(Ind2));
                NZA = NZA + 1;
            end
        end
    end

    MatKK = sparse(IRN,ICN,K0);
    Diag = diag(MatKK);
    MatKK = MatKK + MatKK' - diag(Diag);
    K = full(MatKK);
%     K=sparse(K);
end
