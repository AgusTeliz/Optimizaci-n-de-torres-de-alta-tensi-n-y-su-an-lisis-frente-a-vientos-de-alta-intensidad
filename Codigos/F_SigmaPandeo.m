%-----------------  F_MountSigma(X,VecU) ----------------------
%--------------------------------------------------------------

function [SigmaPandeo] = F_SigmaPandeo(X)

global NumElementos NumVarPos NumVarSec VS Ax FS_opcional;
global N1 N2 Si XX YY ZZ VX VY VZ Co Ma EE;
global MatElementos MatNodos MatSisCoord MatMaterialesR ;

global MatVarPosR MatVarSecR

        MatVarSecR(1:NumVarSec,1)= X(1:NumVarSec,1);
        MatVarPosR(1:NumVarPos,1)= X(NumVarSec+1:NumVarPos+NumVarSec,1);

SigmaPandeo = zeros(NumElementos,1);

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
    
    DX = (X2 - X1)/3; % Distancia en mm 
    DY = (Y2 - Y1)/3; % Divido 3 ya que en la realidad exise mayor 
    DZ = (Z2 - Z1)/3; % cantidad de barras que arriostran al sistema
    
    LL = 1000*sqrt(DX*DX + DY*DY + DZ*DZ);   
    VarS = MatElementos(Elem,VS);
    Aele = MatVarSecR(VarS,Ax);
    Mate = MatElementos(Elem,Ma);
    Eele = MatMaterialesR(Mate,EE);
    
    SigmaPandeo(Elem) = -(pi^2*Eele*F_Inercia_A(Aele)/(LL^2))/1.67/FS_opcional;
end

end

                       









