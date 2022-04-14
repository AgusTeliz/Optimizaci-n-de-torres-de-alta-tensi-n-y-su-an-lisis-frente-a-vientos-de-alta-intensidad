%-----------   analysis_init   ------------------------------
%------------------------------------------------------------

%%%   Matriz de Secciones   %%%
% MatVarSec, matriz de seccion variable (1e-4 metro cuadrado = 1 cm cuadrado)
% MatSecFix, matriz de secciones fijas
    MatVarSecR = [MatVarSec(:,[2,5,6]) ; MatVarSecFix(:,[2,2,2])];
    MatVarSecI =  MatVarSec(:,3:4);
        % Numero de variables de seccion transversal de las barras
        NumVarSec = size(MatVarSec,1);    
        % Numero de secciones fijas
        NumVarSecFix = size(MatVarSecFix,1);


%%%   Matriz de Distancias   %%%
% MatVarPos, matriz de posiciones variables
% MatVarPosFix, matriz de posiciones fijas
    MatVarPosR = [MatVarPos(:,[2 5 6]);  MatVarPosFix(:,[2 2 2])];         
    MatVarPosI = MatVarPos(:,3:4);
        % Numero de variables de posicion
        NumVarPos = size(MatVarPos,1);
        % Numero de posicoines fixas
        NumVarPosFix = size(MatVarPosFix,1);


%%%   Matriz de sistemas de coordenadas   %%%
% MatSisCoord, matriz de sistemas de coordenadas
    MatSisCoord=MatSisCoord(:,2:end);
    % Numero de sistemas de coordenadas
    NumSisCoord = size(MatSisCoord,1);


%%%   Matriz de Nodos %%%
% MatNo, matriz de coordenadas nodales
    MatNodos=MatNodos(:,2:end);
        % Numero de nodos
        NumNodos = size(MatNodos,1);


%%%   Matriz de Materiales   %%%
% MatMat, matriz de parametros de los materiales
    MatMaterialesR = MatMateriales(:,[2 3 4 5 8 9]);
    MatMaterialesI = MatMateriales(:,6:7);
        % Numero de materiais
        NumMateriales = size(MatMateriales,1);


%%%   Matriz de Elementos   %%%
% MatElem, matriz de barras
    MatElementos = MatElementos(:,2:end);
        % Numero de barras
        NumElementos = size(MatElementos,1);


%%%   Números de estados de carga y Matriz de condición de borde   %%%
% MatCondBorde, matriz de condiciones de Borde
    MatCondBordeR = MatCondBorde(:,5:7);
    MatCondBordeI = MatCondBorde(:,2:4);
        % Numero de condiciones de Borde
        NumCondBorde = size(MatCondBorde,1);


%%%   Matriz de condición de borde en nodos   %%%
% Numero de estados de carregamento
    NumEstCarga = max(MatCondBordeNodos(:,3));
% MatCondNo, matriz de condiciones de contorno en nodos
    MatCondBordeNodos = MatCondBordeNodos(:,2:end);
        % Numero de condiciones en nodos
        NumCondBordeNodos = size(MatCondBordeNodos,1);


%%%   Matriz de Restricción de colinealidad   %%%
% MatRestrCol, matriz de restricciones de colinealidad
    MatResCol = MatResCol(:,2:4);
        % Numero de restricciones de colinealidad
        NumResCol = size(MatResCol,1);
        
%%%   Matriz de Restricción de dislocamiento   %%%
% MatRestrDesp, matriz de restricciones de dislocamento
    MatResDesR = MatResDes(:,6:7);
    MatResDesI = MatResDes(:,2:5);
        %Numero de restricciones de dislocamento
        NumResDes = size(MatResDes,1);

%%%   Numero de variables   %%%
% Numero de variables sin variables alpha.
NumVar = NumVarSec + NumVarPos; % + NumResCol;

%****************
%* Dimensiones **
%****************
NGN = 3;
NGE = 6;

%****************
%**  Columnas  **
%****************

Ax  = 1;
Bi  = 2;
Bs  = 3;
Ti  = 1;
Ts  = 2;
Co  = 1;
XX  = 1;
YY  = 2;
ZZ  = 3;
VX  = 1;
VY  = 2;
VZ  = 3;
Si  = 4;
EE  = 1;
vv  = 2;
DD  = 3;
Cu  = 4;
TC  = 5;
TT  = 6;
TAC = 1;
TAT = 2;
N1  = 1;
N2  = 2;
N3  = 3;
VS  = 3;
Ma  = 4;
TX  = 1;
TY  = 2;
TZ  = 3;
No  = 1;
Es  = 2;
Cd  = 3;

NDL = 1;
NDF = 2;
NVP = 3;
DG1 = 4;
DG2 = 5;
DG3 = 6;
DL1 = 7;
DL2 = 8;
DL3 = 9;
DF1 = 10;
DF2 = 11;
DF3 = 12;
VP1 = 13;
VP2 = 14;
VP3 = 15;
VL1 = 16;
VL2 = 17;
VL3 = 18;
NVL = 1;
VGL = 2;

%****************
%**  Numeros  ***
%****************
CD0 = 0.0;
CD1 = 1.0;
CD2 = 2.0;
CD3 = 3.0;
CI2 = 0.5;
CI3 = CD1/CD3;
CDP = pi;

%------------------------------------------------------------
% Coloco condiciones de borde en MatUo y MatFo --------------

MatUo = zeros(NumNodos,NGN,NumEstCarga);
MatFo = zeros(NumNodos,NGN,NumEstCarga);
MatGrLib = zeros(NumNodos,3+5*NGN);
MatVaLib = zeros(NumElementos,2);

VecAlfa  = zeros(NumResCol,1);
VecAlfa0 = zeros(NumResCol,1);
        
for Ind = 1:NumCondBordeNodos
    NodG = MatCondBordeNodos(Ind,No);
    Est  = MatCondBordeNodos(Ind,Es);
    Cond = MatCondBordeNodos(Ind,Cd);
    PosT  = TX;
    PosDG = DG1;
    for GrL = 1:3
        if (MatCondBordeI(Cond,PosT) == 0)
            MatGrLib(NodG,PosDG) = 1;
            MatUo(NodG,GrL,Est) = MatUo(NodG,GrL,Est) + MatCondBordeR(Cond,PosT);
        else
            MatFo(NodG,GrL,Est) = MatFo(NodG,GrL,Est) + MatCondBordeR(Cond,PosT);
        end
        PosT  = PosT  + 1;
        PosDG = PosDG + 1;
    end
end

% defino MatGrLib -------------------------------------------------------------------

NumGrLib = 0;
NumGrFix = 0;

for NodG = 1:NumNodos
    PosDG = DG1;
    PosDL = DL1;
    PosDF = DF1;
    PosVP = VX;
    PosPG = VP1;
    PosPL = VL1;
    for GrL = 1:3
        if (MatGrLib(NodG,PosDG) == 0)
            NumGrLib = NumGrLib + 1;
            MatGrLib(NodG,PosDG) = NumGrLib;
            MatGrLib(NodG,NDL) = MatGrLib(NodG,NDL) + 1;
            MatGrLib(NodG,PosDL) = GrL;
            PosDL = PosDL + 1;
        else
            NumGrFix = NumGrFix + 1;
            MatGrLib(NodG,PosDG) = NumGrFix;
            MatGrLib(NodG,NDF) = MatGrLib(NodG,NDF) + 1;
            MatGrLib(NodG,PosDF) = GrL;
            PosDF = PosDF + 1;
        end
        
        if (MatNodos(NodG,PosVP) <= NumVarPos)
            MatGrLib(NodG,PosPG) = MatNodos(NodG,PosVP) + NumVarSec;
            MatGrLib(NodG,NVP) = MatGrLib(NodG,NVP) + 1;
            MatGrLib(NodG,PosPL) = GrL;
            PosPL = PosPL + 1;
        end
        
        PosDG = PosDG + 1;
        PosVP = PosVP + 1;
        PosPG = PosPG + 1;
    end
end

%************************************************************************************
% Inicializo ------------------------------------------------------------------------

TAM = 2*(6*NumNodos+9*NumElementos);
MatK = zeros(TAM,1); % 2 veces o nÃºmero mÃ¡ximo posÃ­vel de elementos da matriz de rigidez
IRN = zeros(TAM,1);
ICN = zeros(TAM,1);

MatElemAux = zeros(NumElementos,3);
MatNodosAux = zeros(NumNodos);
NZ = 0;

%************************************************************************************
%   Matriz de rigidez ---------------------------------------------------------------

for Elem = 1:NumElementos
    
    %   Matriz elemento -----------------------------------------------------------------
    
    Nod1 = MatElementos(Elem,N1); % Se supone que Nod1 < Nod2 (Ver: Cambio orden en Lectura)
    Nod2 = MatElementos(Elem,N2);
    
    %   Monto vectores GrGE y GrLE ------------------------------------------------------
    
    NodL = N1;
    NodG = MatElementos(Elem,NodL);
    GrGN1 = MatGrLib(NodG,DG1:DG3);
    NGLN1 = MatGrLib(NodG,NDL);
    GrLN1 = MatGrLib(NodG,DL1:DL3);
    
    NodL = N2;
    NodG = MatElementos(Elem,NodL);
    GrGN2 = MatGrLib(NodG,DG1:DG3);
    NGLN2 = MatGrLib(NodG,NDL);
    GrLN2 = MatGrLib(NodG,DL1:DL3);
    
    VarS = MatElementos(Elem,VS);
    
    if (VarS <= NumVarSec)
        MatVaLib(Elem,NVL) = 1;
        MatVaLib(Elem,VGL) = VarS;
    end
    
    % Monto matrices MatK y MatR, y vectores VecF y VecR ------------------------------
    
    % MatK(GrGE(GrLE(Ind1)),GrGE(GrLE(Ind2))) = MatK((GrL(LInd1)),GrGE(GrLE(Ind2))) + Ke(GrLE(Ind1),GrLE(Ind2))
    
    % Nodo 1
    if (MatNodosAux(Nod1) == 0)
        MatElemAux(Elem,1) = NZ + 1;
        MatNodosAux(Nod1) = NZ + 1;
        for Ind1 = 1:NGLN1
            for Ind2 = Ind1:NGLN1
                NZ = NZ + 1;
                MatK(NZ) = CD1;
                IRN(NZ) = GrGN1(GrLN1(Ind1));
                ICN(NZ) = GrGN1(GrLN1(Ind2));
            end
        end
    else
        NZA = MatNodosAux(Nod1);
        MatElemAux(Elem,1) = NZA;
        for Ind1 = 1:NGLN1
            for Ind2 = Ind1:NGLN1
                MatK(NZA) = MatK(NZA) + CD1;
                NZA = NZA + 1;
            end
        end
    end
    
    % Nodo 2
    if (MatNodosAux(Nod2) == 0)
        MatElemAux(Elem,2) = NZ + 1;
        MatNodosAux(Nod2) = NZ + 1;
        for Ind1 = 1:NGLN2
            for Ind2 = Ind1:NGLN2
                NZ = NZ + 1;
                MatK(NZ) = CD1;
                
                IRN(NZ) = GrGN2(GrLN2(Ind1));
                ICN(NZ) = GrGN2(GrLN2(Ind2));
            end
        end
    else
        NZA = MatNodosAux(Nod2);
        MatElemAux(Elem,2) = NZA;
        for Ind1 = 1:NGLN2
            for Ind2 = Ind1:NGLN2
                MatK(NZA) = MatK(NZA) + CD1;
                NZA = NZA + 1;
            end
        end
    end
    
    % Nodo 1-2
    MatElemAux(Elem,3) = NZ + 1;
    for Ind1 = 1:NGLN1
        for Ind2 = 1:NGLN2
            NZ = NZ + 1;
            MatK(NZ) = CD1;
            IRN(NZ) = GrGN1(GrLN1(Ind1));
            ICN(NZ) = GrGN2(GrLN2(Ind2));
        end
    end
end

%************************************************************************************
%   Vector Alfa inicial -------------------------------------------------------------

for Col = 1:NumResCol
    
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
    
    DX1 = X2-X1; DX2 = X3-X1;
    DY1 = Y2-Y1; DY2 = Y3-Y1;
    DZ1 = Z2-Z1; DZ2 = Z3-Z1;
    
    LL1 = sqrt(DX1*DX1 + DY1*DY1 + DZ1*DZ1);
    LL2 = sqrt(DX2*DX2 + DY2*DY2 + DZ2*DZ2);
    
    VecAlfa0(Col) = LL2/LL1;
end

%************************************************************************************
%   Anï¿½lisis MA27 -------------------------------------------------------------------

% Aqui el anï¿½lisis de MA27 para MatK
% CALL MA27ID(ICNTL,CNTL)
[~,~,IRN] = find(IRN);
[~,~,ICN] = find(ICN);
[~,~,MatK] = find(MatK);
A = sparse(IRN,ICN,MatK);
%MatKK = sparse(IRN,ICN,MatK);

% STORE ARRAY LENGTHS
% LIW = 10000  % ??????

% ICNTL(1) = 6 % ??????

% ASK FOR FULL PRINTING FROM MA27 PACKAGE
% ICNTL(3) = 0

% SET IFLAG TO INDICATE PIVOT SEQUENCE IS TO BE FOUND BY MA27AD
% IFLAG = 0

% ANALYSE SPARSITY PATTERN
% allocate(IW1(2*NumGrLib))
% allocate(W(NumGrLib))
% call MA27AD(NumGrLib,NZ,IRN,ICN,IW,LIW,IKEEP,IW1,NSTEPS,IFLAG,ICNTL,CNTL,INFO,OPS)

%************************************************************************************
%   Inicializo vector de variables --------------------------------------------------

MontadaMK = 0;

%return
%************************************************************************************
%   alloco e inicializo as variaveis necessarias para fazer o call io_set() ---------
%
%VecU = CD0
%VecR = CD0
%call MountResElem(MatResElem,VecU)
%call io_set(NumGrLib,NumGrFix,MatGrLib,VecU,VecR,MatResElem,MatVarSecR,MatVarPosR)


% Plot
X0 = [MatVarSecR(1:NumVarSec,1); MatVarPosR(1:NumVarPos,1)];





