%%%%%%%%%%%    P_MountCost    %%%%%%%%%%%

function [f] = F_MountCost(X)

    global NumElementos NumVarPos NumVarSec N1 N2 Si XX YY ZZ VX VY VZ Co VS Ma Ax DD Cu
    global MatElementos MatNodos MatSisCoord MatMaterialesR;
    global MatVarPosR MatVarSecR

    MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
    MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

    f = 0;

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

        VarS = MatElementos(Elem,VS);
        Mate = MatElementos(Elem,Ma);

        Aele = MatVarSecR(VarS,Ax);
        Dele = MatMaterialesR(Mate,DD);
        Cele = MatMaterialesR(Mate,Cu);

        f = f + Cele*Dele*Aele*LL;
    end
end