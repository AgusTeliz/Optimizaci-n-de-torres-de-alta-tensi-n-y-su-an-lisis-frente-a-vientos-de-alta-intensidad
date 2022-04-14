%----------------  F_MountCol(h)  -----------------------------
%--------------------------------------------------------------

function [h] = F_MountCol(X)

    global  NumVarPos NumVarSec NGN ;
    global  N1 N2 N3 Si XX YY ZZ VX VY VZ Co  CD1  NumResCol ;
    global  MatNodos MatSisCoord MatResCol ;
    global  VecAlfa0 MatVarPosR ;

    MatVarPosR(1:NumVarPos,1) = X(NumVarSec+1:NumVarPos+NumVarSec,1);

    h   = zeros(NumResCol*NGN,1);
    Pos = 0;

    for Col = 1 : NumResCol

        %************************************************************************************
        % Matriz elemento -------------------------------------------------------------------

        Nod3 = MatResCol(Col,N1);
        Nod1 = MatResCol(Col,N2);
        Nod2 = MatResCol(Col,N3);

        Sis1 = MatNodos(Nod1,Si);
        Sis2 = MatNodos(Nod2,Si);
        Sis3 = MatNodos(Nod3,Si);

        Co1X = MatSisCoord(Sis1,XX);
        Co1Y = MatSisCoord(Sis1,YY);
        Co1Z = MatSisCoord(Sis1,ZZ);
        Co2X = MatSisCoord(Sis2,XX);
        Co2Y = MatSisCoord(Sis2,YY);
        Co2Z = MatSisCoord(Sis2,ZZ);
        Co3X = MatSisCoord(Sis3,XX);
        Co3Y = MatSisCoord(Sis3,YY);
        Co3Z = MatSisCoord(Sis3,ZZ);

        Var1X = MatNodos(Nod1,VX);
        Var1Y = MatNodos(Nod1,VY);
        Var1Z = MatNodos(Nod1,VZ);
        Var2X = MatNodos(Nod2,VX);
        Var2Y = MatNodos(Nod2,VY);
        Var2Z = MatNodos(Nod2,VZ);
        Var3X = MatNodos(Nod3,VX);
        Var3Y = MatNodos(Nod3,VY);
        Var3Z = MatNodos(Nod3,VZ);

        X1 = Co1X*MatVarPosR(Var1X,Co);
        Y1 = Co1Y*MatVarPosR(Var1Y,Co);
        Z1 = Co1Z*MatVarPosR(Var1Z,Co);
        X2 = Co2X*MatVarPosR(Var2X,Co);
        Y2 = Co2Y*MatVarPosR(Var2Y,Co);
        Z2 = Co2Z*MatVarPosR(Var2Z,Co);
        X3 = Co3X*MatVarPosR(Var3X,Co);
        Y3 = Co3Y*MatVarPosR(Var3Y,Co);
        Z3 = Co3Z*MatVarPosR(Var3Z,Co);

        Alfa = VecAlfa0(Col);

        Pos    = Pos + 1;
        h(Pos) = (CD1-Alfa)*X1 + (Alfa)*X2 - X3;
        Pos    = Pos + 1;
        h(Pos) = (CD1-Alfa)*Y1 + (Alfa)*Y2 - Y3;
        Pos    = Pos + 1;
        h(Pos) = (CD1-Alfa)*Z1 + (Alfa)*Z2 - Z3;
    end
end