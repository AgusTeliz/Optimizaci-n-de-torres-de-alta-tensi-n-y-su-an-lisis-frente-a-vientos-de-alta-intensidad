%-----------   F_MountDCost(Df)  ------------------------------
%------------------------------------------------------------
function [Df] = F_MountDCost(X)

    global NumElementos NumVarPos NumVarSec ;
    global N1 N2 Si XX YY ZZ VX VY VZ Co VS Ma Ax DD Cu NumVar CD1 CD2;
    global CI2 VP1 VP3 NVP VL1 VL3 NGN NVL VGL;
    global MatElementos MatNodos MatSisCoord MatMaterialesR MatGrLib MatVaLib;
    global MatVarPosR MatVarSecR

    MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
    MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

    Df = zeros(1,NumVar);

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

        gX1 = zeros(1,7); gX1(2) = Co1X;
        gY1 = zeros(1,7); gY1(3) = Co1Y;
        gZ1 = zeros(1,7); gZ1(4) = Co1Z;
        gX2 = zeros(1,7); gX2(5) = Co2X;
        gY2 = zeros(1,7); gY2(6) = Co2Y;
        gZ2 = zeros(1,7); gZ2(7) = Co2Z;

        DX = X2 - X1; gDX = gX2-gX1;
        DY = Y2 - Y1; gDY = gY2-gY1;
        DZ = Z2 - Z1; gDZ = gZ2-gZ1;

        LQ = DX*DX + DY*DY + DZ*DZ;
        LL = 1000 * sqrt(LQ); %Para pasar a mm
        LI = CD1/LL;

        gLQ = (CD2*DX)*gDX + (CD2*DY)*gDY + (CD2*DZ)*gDZ;
        gLL = (CI2*LI*1e6)*gLQ;

        VarS = MatElementos(Elem,VS);
        Mate = MatElementos(Elem,Ma);

        Aele = MatVarSecR(VarS,Ax);
        Dele = MatMaterialesR(Mate,DD);
        Cele = MatMaterialesR(Mate,Cu);

        gf = zeros(1,7); gf(1) = Cele*Dele*LL;
        gf = gf + (Cele*Dele*Aele)*gLL;
 
        %************************************************************************************
        % Monto vectores GrLE y UeGE ------------------------------------------------------

        NodL = N1;
        NodG = MatElementos(Elem,NodL);
        VaGN1 = MatGrLib(NodG,VP1:VP3);
        NVLN1 = MatGrLib(NodG,NVP);
        VaLN1 = MatGrLib(NodG,VL1:VL3) + 1;

        NodL = N2;
        NodG = MatElementos(Elem,NodL);
        VaGN2 = MatGrLib(NodG,VP1:VP3);
        NVLN2 = MatGrLib(NodG,NVP);
        VaLN2 = MatGrLib(NodG,VL1:VL3) + 1 + NGN;

        NVSE = MatVaLib(Elem,NVL);
        NVLE = NVSE + NVLN1 + NVLN2;
        VaGE(1)   = MatVaLib(Elem,VGL);
        VaGE(2:4) = VaGN1;
        VaGE(5:7) = VaGN2;
        VaLE(1:NVSE)            = MatVaLib(Elem,1:NVSE); %Gambiarra
        VaLE(NVSE+1:NVSE+NVLN1) = VaLN1(1:NVLN1);
        VaLE(NVSE+NVLN1+1:NVLE) = VaLN2(1:NVLN2);

        %************************************************************************************
        % Monto Vector Df -------------------------------------------------------------------

        for Var = 1 : NVLE
            Df(VaGE(VaLE(Var))) = Df(VaGE(VaLE(Var))) + gf(VaLE(Var));
        end
    end
end
