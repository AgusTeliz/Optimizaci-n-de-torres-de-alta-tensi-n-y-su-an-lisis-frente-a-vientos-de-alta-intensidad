%---------  F_MountDKVU(DKVU,VecU) ----------------------------
%--------------------------------------------------------------
function [DKVU] = F_MountDKVU(X,VecU)

    global NumElementos N1 N2 Si XX YY ZZ VX VY VZ Co Ma EE CD1 NDL DL1 DL3 NGN   ;
    global VS  Ax NumGrLib NumEstCarga NumVar NumVarPos NumVarSec ;
    global CD2 CI2 DG1 DG3 VP1 VP3 NVP VL1 VL3 NVL VGL ;
    global MatElementos MatNodos MatSisCoord MatMaterialesR MatGrLib MatVaLib ;
    global MatVarPosR MatVarSecR

    MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
    MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

    DKVU = zeros(NumGrLib*NumEstCarga,NumVar);

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

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%  Propiedades geom�tricas del elemento y propiedades del material  %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        VarS = MatElementos(Elem,VS);
        Mate = MatElementos(Elem,Ma);

        Aele = MatVarSecR(VarS,Ax);
        Eele = MatMaterialesR(Mate,EE);

        EAele  = Aele*Eele;
        gEAele = zeros(1,7); gEAele(1) = Eele;

        EAxL = LI*EAele; gEAxL = EAele*gLI + LI*gEAele;

        XLXL = XL*XL; gXLXL = (CD2*XL)*gXL;
        YLYL = YL*YL; gYLYL = (CD2*YL)*gYL;
        ZLZL = ZL*ZL; gZLZL = (CD2*ZL)*gZL;
        XLYL = XL*YL; gXLYL = YL*gXL + XL*gYL;
        XLZL = XL*ZL; gXLZL = ZL*gXL + XL*gZL;
        YLZL = YL*ZL; gYLZL = ZL*gYL + YL*gZL;

        %Ke11 = EAxL*XLXL;
        gKe11 = XLXL*gEAxL + EAxL*gXLXL;
        %Ke12 = EAxL*XLYL;
        gKe12 = XLYL*gEAxL + EAxL*gXLYL;
        %Ke13 = EAxL*XLZL;
        gKe13 = XLZL*gEAxL + EAxL*gXLZL;
        %Ke14 = -Ke11;
        %Ke15 = -Ke12;
        %Ke16 = -Ke13;
        %Ke22 = EAxL*YLYL;
        gKe22 = YLYL*gEAxL + EAxL*gYLYL;
        %Ke23 = EAxL*YLZL;
        gKe23 = YLZL*gEAxL + EAxL*gYLZL;
        %Ke24 = -Ke12;
        %Ke25 = -Ke22;
        %Ke26 = -Ke23;
        %Ke33 = EAxL*ZLZL;
        gKe33 = ZLZL*gEAxL + EAxL*gZLZL;
        %Ke34 = -Ke13;
        %Ke35 = -Ke23;
        %Ke36 = -Ke33;
        %Ke44 = Ke11;
        %Ke45 = Ke12;
        %Ke46 = Ke13;
        %Ke55 = Ke22;
        %Ke56 = Ke23;
        %Ke66 = Ke33;

        %Ke21 = Ke12;
        %Ke31 = Ke13;
        %Ke32 = Ke23;
        %Ke41 = Ke14;
        %Ke42 = Ke24,
        %Ke43 = Ke34;
        %Ke51 = Ke15;
        %Ke52 = Ke25;
        %Ke53 = Ke35;
        %Ke54 = Ke45,
        %Ke61 = Ke16;
        %Ke62 = Ke26;
        %Ke63 = Ke36;
        %Ke64 = Ke46;
        %Ke65 = Ke56;

        %************************************************************************************
        % Monto vectores GrLE y UeGE ------------------------------------------------------

        NodL  = N1;
        NodG  = MatElementos(Elem,NodL);
        GrGN1 = MatGrLib(NodG,DG1:DG3);
        NGLN1 = MatGrLib(NodG,NDL);
        GrLN1 = MatGrLib(NodG,DL1:DL3);

        VaGN1 = MatGrLib(NodG,VP1:VP3);
        NVLN1 = MatGrLib(NodG,NVP);
        VaLN1 = MatGrLib(NodG,VL1:VL3) + 1;

        NodL  = N2;
        NodG  = MatElementos(Elem,NodL);
        GrGN2 = MatGrLib(NodG,DG1:DG3);
        NGLN2 = MatGrLib(NodG,NDL);
        GrLN2 = MatGrLib(NodG,DL1:DL3) + NGN;

        VaGN2 = MatGrLib(NodG,VP1:VP3);
        NVLN2 = MatGrLib(NodG,NVP);
        VaLN2 = MatGrLib(NodG,VL1:VL3) + 1 + NGN;

        NGLE = NGLN1 + NGLN2		;
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

        PosL = 0;
        for Est = 1 : NumEstCarga
            Ue = zeros(6,1);
            for Ind = 1 : NGLE
                Ue(GrLE(Ind)) = VecU(GrGE(GrLE(Ind))+PosL);
            end
            DUX = Ue(1)-Ue(4);
            DUY = Ue(2)-Ue(5);
            DUZ = Ue(3)-Ue(6);
            %Fe(1) = Ke11*DUX + Ke12*DUY + Ke13*DUZ;
            gFe(1,:) = DUX*gKe11 + DUY*gKe12 + DUZ*gKe13;
            %Fe(2) = Ke12*DUX + Ke22*DUY + Ke23*DUZ;
            gFe(2,:) = DUX*gKe12 + DUY*gKe22 + DUZ*gKe23;
            %Fe(3) = Ke13*DUX + Ke23*DUY + Ke33*DUZ;
            gFe(3,:) = DUX*gKe13 + DUY*gKe23 + DUZ*gKe33;
            %Fe(4) = -Fe(1);
            gFe(4,:) = -gFe(1,:);
            %Fe(5) = -Fe(2);
            gFe(5,:) = -gFe(2,:);
            %Fe(6) = -Fe(3);
            gFe(6,:) = -gFe(3,:);

            for Ind = 1 : NGLE
                %VecF(GrGE(GrLE(Ind))+Pos) = VecF(GrGE(GrLE(Ind))+Pos) + Fe(GrLE(Ind));
                for Var = 1 : NVLE
                    DKVU(GrGE(GrLE(Ind))+PosL,VaGE(VaLE(Var))) = DKVU(GrGE(GrLE(Ind))+PosL,VaGE(VaLE(Var))) + gFe(GrLE(Ind),VaLE(Var));
                end
            end
            PosL = PosL + NumGrLib;
        end
    end
end

