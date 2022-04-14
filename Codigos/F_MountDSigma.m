%---------- F_MountDSigma(MatDSigma,VecU,MatDU) ---------------
%------------------------------------------------------------
function [MatDSigma] = F_MountDSigma(X,VecU,MatDU)
    
    global NumElementos NumVarPos NumVarSec NumVar;
    global N1 N2 Si XX YY ZZ VX VY VZ Co Ma EE CD1 DG1 DG3 NDL DL1   ;
    global DL3 NGN NumEstCarga NumGrLib CD2 CI2 VP1 VP3 NVP VL1 VL3 NVL  VGL NGE;
    global MatElementos MatNodos MatSisCoord MatMaterialesR MatGrLib MatVaLib;
    global MatVarPosR MatVarSecR
        
    MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
    MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

    MatDSigma = zeros(NumElementos*NumEstCarga,NumVar);
 
    for Elem = 1 : NumElementos
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

        gX1=zeros(1,7); gX1(2) = Co1X;
        gY1=zeros(1,7); gY1(3) = Co1Y;
        gZ1=zeros(1,7); gZ1(4) = Co1Z;
        gX2=zeros(1,7); gX2(5) = Co2X;
        gY2=zeros(1,7); gY2(6) = Co2Y;
        gZ2=zeros(1,7); gZ2(7) = Co2Z;

        DX = X2 - X1; gDX = gX2-gX1;
        DY = Y2 - Y1; gDY = gY2-gY1;
        DZ = Z2 - Z1; gDZ = gZ2-gZ1;

        LQ = DX*DX + DY*DY + DZ*DZ;
        LL = sqrt(LQ);
        LI = CD1/LL;

        gLQ = (CD2*DX)*gDX + (CD2*DY)*gDY + (CD2*DZ)*gDZ;
        gLL = (CI2*LI)*gLQ;
        gLI = (-LI*LI)*gLL;

        XL = LI*DX; gXL = DX*gLI + LI*gDX;
        YL = LI*DY; gYL = DY*gLI + LI*gDY;
        ZL = LI*DZ; gZL = DZ*gLI + LI*gDZ;

        Mate = MatElementos(Elem,Ma);
        Eele = MatMaterialesR(Mate,EE);

        %************************************************************************************
        % Monto vectores GrLE y UeGE ------------------------------------------------------

        NodL = N1;
        NodG = MatElementos(Elem,NodL);
        GrGN1 = MatGrLib(NodG,DG1:DG3);
        NGLN1 = MatGrLib(NodG,NDL);
        GrLN1 = MatGrLib(NodG,DL1:DL3);

        VaGN1 = MatGrLib(NodG,VP1:VP3);
        NVLN1 = MatGrLib(NodG,NVP);
        VaLN1 = MatGrLib(NodG,VL1:VL3) + 1;

        NodL = N2;
        NodG = MatElementos(Elem,NodL);
        GrGN2 = MatGrLib(NodG,DG1:DG3);
        NGLN2 = MatGrLib(NodG,NDL);
        GrLN2 = MatGrLib(NodG,DL1:DL3) + NGN;

        VaGN2 = MatGrLib(NodG,VP1:VP3);
        NVLN2 = MatGrLib(NodG,NVP);
        VaLN2 = MatGrLib(NodG,VL1:VL3) + 1 + NGN;

        NGLE = NGLN1 + NGLN2;
        GrGE(1:3) = GrGN1;
        GrGE(4:6) = GrGN2;
        GrLE(1:NGLN1)      = GrLN1(1:NGLN1);
        GrLE(NGLN1+1:NGLE) = GrLN2(1:NGLN2);

        NVSE = MatVaLib(Elem,NVL);
        NVLE = NVSE + NVLN1 + NVLN2;
        VaGE(1)   = MatVaLib(Elem,VGL);
        VaGE(2:4) = VaGN1;
        VaGE(5:7) = VaGN2;
        VaLE(1:NVSE)            = MatVaLib(Elem,1:NVSE); %Gambiarra
        VaLE(NVSE+1:NVSE+NVLN1) = VaLN1(1:NVLN1);
        VaLE(NVSE+NVLN1+1:NVLE) = VaLN2(1:NVLN2);

        %************************************************************************************
        % Monto matrices MatK y MatR, y vectores VecF y VecR --------------------------------

        PosE = 0;
        PosL = 0;
        for Est = 1 : NumEstCarga
            Ue  = zeros(1,6);
            gUe = zeros(NGE,NumVar);
            for Ind = 1 : NGLE
                Ue(GrLE(Ind))    = VecU (GrGE(GrLE(Ind))+PosL);
                gUe(GrLE(Ind),:) = MatDU(GrGE(GrLE(Ind))+PosL,:);
            end
            DUX = Ue(4)-Ue(1); gDUX = gUe(4,:)-gUe(1,:);
            DUY = Ue(5)-Ue(2); gDUY = gUe(5,:)-gUe(2,:);
            DUZ = Ue(6)-Ue(3); gDUZ = gUe(6,:)-gUe(3,:);

            DL  = DUX*XL + DUY*YL + DUZ*ZL;
            gDL = XL*gDUX + YL*gDUY + ZL*gDUZ;
            for Var = 1 : NVLE
                gDL(VaGE(VaLE(Var))) = gDL(VaGE(VaLE(Var))) + DUX*gXL(VaLE(Var)) + DUY*gYL(VaLE(Var)) + DUZ*gZL(VaLE(Var));
            end

            % SE  = LI*DL*Eele;
            gSE = LI*Eele*gDL;
            for Var = 1 : NVLE
                gSE(VaGE(VaLE(Var))) = gSE(VaGE(VaLE(Var))) + DL*Eele*gLI(VaLE(Var));
            end

            MatDSigma(Elem+PosE,:) = gSE;
            PosE = PosE + NumElementos;
            PosL = PosL + NumGrLib;
        end
    end