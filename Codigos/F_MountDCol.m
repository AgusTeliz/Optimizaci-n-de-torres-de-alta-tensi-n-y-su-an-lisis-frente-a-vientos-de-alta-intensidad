%-----------   F_MountDCol(Dh)   ------------------------------
%------------------------------------------------------------
function [Dh] = F_MountDCol(X)

    global  NumVarPos NumVarSec NGN NumVar VP1 VP3 NVP VL1 VL3;
    global  N1 N2 N3 Si XX YY ZZ VX VY VZ Co  CD1  NumResCol;
    global  MatNodos MatSisCoord MatResCol MatGrLib MatVarPosR;
    global  VecAlfa0;

    MatVarPosR(1:NumVarPos,1) = X(NumVarSec+1:NumVarPos+NumVarSec,1);

    Dh = zeros(NumResCol*NGN,NumVar+NumResCol);

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
%       Var3X = MatNodos(Nod3,VX);
%       Var3Y = MatNodos(Nod3,VY);
%       Var3Z = MatNodos(Nod3,VZ);

        X1 = Co1X*MatVarPosR(Var1X,Co);
        Y1 = Co1Y*MatVarPosR(Var1Y,Co);
        Z1 = Co1Z*MatVarPosR(Var1Z,Co);
        X2 = Co2X*MatVarPosR(Var2X,Co);
        Y2 = Co2Y*MatVarPosR(Var2Y,Co);
        Z2 = Co2Z*MatVarPosR(Var2Z,Co);
%       X3 = Co3X*MatVarPosR(Var3X,Co);
%       Y3 = Co3Y*MatVarPosR(Var3Y,Co);
%       Z3 = Co3Z*MatVarPosR(Var3Z,Co);

        gX1=zeros(1,10);
        gY1=zeros(1,10);
        gZ1=zeros(1,10);
        gX2=zeros(1,10);
        gY2=zeros(1,10);
        gZ2=zeros(1,10);
        gX3=zeros(1,10);
        gY3=zeros(1,10);
        gZ3=zeros(1,10);

        gX1(2)  = Co1X;
        gY1(3)  = Co1Y;
        gZ1(4)  = Co1Z;
        gX2(5)  = Co2X;
        gY2(6)  = Co2Y;
        gZ2(7)  = Co2Z;
        gX3(8)  = Co3X;
        gY3(9)  = Co3Y;
        gZ3(10) = Co3Z;

        Alfa = VecAlfa0(Col);

        gAlfa = zeros(1,10); gAlfa(1) = 1;

        gh(1,:) = (X2-X1)*gAlfa + (CD1-Alfa)*gX1 + (Alfa)*gX2 - gX3;
        gh(2,:) = (Y2-Y1)*gAlfa + (CD1-Alfa)*gY1 + (Alfa)*gY2 - gY3;
        gh(3,:) = (Z2-Z1)*gAlfa + (CD1-Alfa)*gZ1 + (Alfa)*gZ2 - gZ3;

        %************************************************************************************
        % Monto vectores GrLE y UeGE ------------------------------------------------------

        NodL  = N2;
        NodG  = MatResCol(Col,NodL);
        VaGN1 = MatGrLib(NodG,VP1:VP3);
        NVLN1 = MatGrLib(NodG,NVP);
        VaLN1 = MatGrLib(NodG,VL1:VL3) + 1;

        NodL  = N3;
        NodG  = MatResCol(Col,NodL);
        VaGN2 = MatGrLib(NodG,VP1:VP3);
        NVLN2 = MatGrLib(NodG,NVP);
        VaLN2 = MatGrLib(NodG,VL1:VL3) + 1 + NGN;

        NodL  = N1;
        NodG  = MatResCol(Col,NodL);
        VaGN3 = MatGrLib(NodG,VP1:VP3);
        NVLN3 = MatGrLib(NodG,NVP);
        VaLN3 = MatGrLib(NodG,VL1:VL3) + 1 + NGN + NGN;

        NVLE = 1 + NVLN1 + NVLN2 + NVLN3;
        VaGE(1)   = Col + NumVarSec + NumVarPos;
        VaGE(2:4) = VaGN1;
        VaGE(5:7) = VaGN2;
        VaGE(8:10)= VaGN3;
        VaLE(1)                       = 1;
        VaLE(1+1:1+NVLN1)             = VaLN1(1:NVLN1);
        VaLE(1+NVLN1+1:1+NVLN1+NVLN2) = VaLN2(1:NVLN2);
        VaLE(1+NVLN1+NVLN2+1:NVLE)    = VaLN3(1:NVLN3);

        %************************************************************************************
        % Monto Vector Dh -------------------------------------------------------------------

        for Res = 1 : 3
            Pos = Pos + 1;
            for Var = 1 : NVLE
                Dh(Pos,VaGE(VaLE(Var))) = Dh(Pos,VaGE(VaLE(Var))) + gh(Res,VaLE(Var));
            end
        end
    end
end













