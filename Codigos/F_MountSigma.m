%-----------------  F_MountSigma(X,VecU) ----------------------
%--------------------------------------------------------------

function [VecSigma] = F_MountSigma(X,VecU)

global NumElementos NumVarPos NumVarSec ;
global N1 N2 Si XX YY ZZ VX VY VZ Co Ma EE CD1 DG1 DG3 NDL DL1   ;
global DL3 NGN NumEstCarga NumGrLib ;
global MatElementos MatNodos MatSisCoord MatMaterialesR MatGrLib ;

global MatVarPosR MatVarSecR

        MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
        MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

VecSigma = zeros(NumElementos*NumEstCarga,1);

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
    
    DX = X2 - X1;
    DY = Y2 - Y1;
    DZ = Z2 - Z1;
    
    LL = sqrt(DX*DX + DY*DY + DZ*DZ);
    LI = CD1/LL;
    
    XL = LI*DX;
    YL = LI*DY;
    ZL = LI*DZ;
    
    Mate = MatElementos(Elem,Ma);
    Eele = MatMaterialesR(Mate,EE);
    
    %************************************************************************************
    % Monto vectores GrLE y UeGE ------------------------------------------------------
    
    NodL  = N1;
    NodG  = MatElementos(Elem,NodL);
    GrGN1 = MatGrLib(NodG,DG1:DG3);
    NGLN1 = MatGrLib(NodG,NDL);
    GrLN1 = MatGrLib(NodG,DL1:DL3);
    
    NodL  = N2;
    NodG  = MatElementos(Elem,NodL);
    GrGN2 = MatGrLib(NodG,DG1:DG3);
    NGLN2 = MatGrLib(NodG,NDL);
    GrLN2 = MatGrLib(NodG,DL1:DL3) + NGN;
    
    NGLE = NGLN1 + NGLN2;
    
    GrGE(1:3) = GrGN1;
    GrGE(4:6) = GrGN2;
    GrLE(1:NGLN1)      = GrLN1(1:NGLN1);
    GrLE(NGLN1+1:NGLE) = GrLN2(1:NGLN2);
    
    %************************************************************************************
    % Monto matrices MatK y MatR, y vectores VecF y VecR --------------------------------
    
    PosE = 0;
    PosL = 0;
    for Est = 1 : NumEstCarga
        Ue = zeros(1,6);
        for Ind = 1:NGLE
            Ue(GrLE(Ind)) = VecU(GrGE(GrLE(Ind))+PosL);%%%%%%%%% VecU
        end
        DUX = Ue(4)-Ue(1);
        DUY = Ue(5)-Ue(2);
        DUZ = Ue(6)-Ue(3);
        
        DL = DUX*XL + DUY*YL + DUZ*ZL;
        SE = Eele*LI*DL; % sigma = E.epsilon = E.delta_l/l 
        
        VecSigma(Elem+PosE) = SE;
        PosE = PosE + NumElementos;
        PosL = PosL + NumGrLib;
    end
end

end

