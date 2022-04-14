close all
clear
clc

P_Global

% MatVarSec, matriz das vari�veis de se��o (1e-4 metro quadrado = 1 cm quadrado)
%            Num    Area    Tmin   Tmax   Amin   Amax  GrD
MatVarSec = [ 1 1e-3 1 1 1e-6 2e-1 1
              2 1 1 1 1e-6 2e-1 1];
% MatSecFix, matriz das se��es fixas
%               Num   Area  (1e-4 metro quadrado = 1 cm quadrado)
MatVarSecFix = [ 3   1e-4];
    MatVarSecR = [MatVarSec(:,[2,5,6]) ; MatVarSecFix(:,[2,2,2])];
    MatVarSecI =  MatVarSec(:,3:4);
        % Numero de variables de seccion transversal de las barras
        NumVarSec = size(MatVarSec,1);    
        % Numero de secciones fixas
        NumVarSecFix = size(MatVarSecFix,1);
    
% MatVarPos, matriz das vari�veis de posi��o
%          Num  Valor  Tmin  Tmax  Pmin  Pmax
MatVarPos=[ 1   0      1    1    0.1    2.0
            2   1      1    1    0.1    2.0];

%            Num    Valor
MatVarPosFix=[ 3 2
               4 3 ]; 
    MatVarPosR = [MatVarPos(:,[2 5 6]);  MatVarPosFix(:,[2 2 2])];         
    MatVarPosI = MatVarPos(:,3:4);
        % Numero de variables de posicion
        NumVarPos = size(MatVarPos,1);
        % Numero de posi��es fixas
        NumVarPosFix = size(MatVarPosFix,1);
    
% MatGrDisc, matriz dos grupos de secciones transversais discretas
%            NumGr  NumVal
MatGrDisc=[   1     4     ];
    % Numero de grupos de se��es transversais discretas
    NumGrDisc = size(MatGrDisc,1);

%MatValDisc, matriz dos valores discretos para um grupo especifico
%             Num     Val
MatValDisc=[1   1e-4
            2   10e-4
            3   20e-4
            4   40e-4];

% MatSisCoord, matriz de sistemas de coordenadas
%              Num    X  Y  Z
MatSisCoord=[1  1  1 1
             2 -1  1 1
             3 -1 -1 1
             4  1 -1 1]; MatSisCoord=MatSisCoord(:,2:end);
    % Numero de sistemas de coordenadas
    NumSisCoord = size(MatSisCoord,1);

% MatNo, matriz de coordenadas nodais
%         Num   Cx    Cy    Cz    Sistema
MatNodos=[1  2  2  1 2
          2  1  2  1 1
          3  1  1  1 1 ];MatNodos=MatNodos(:,2:end);
        % Numero de nodos
        NumNodos = size(MatNodos,1);

% MatMat, matriz de par�metros dos materiais
%       Num   Y  P  D  C  Tac  Tat tac   tat
MatMateriales=[1 200e3 0.3 7.8 1.0 1 1 250 250];
    MatMaterialesR = MatMateriales(:,[2 3 4 5 8 9]);
    MatMaterialesI = MatMateriales(:,6:7);
        % Numero de materiais
        NumMateriales = size(MatMateriales,1);

% Material -> Acero ASTM A36 (E = 200e6 N/m2, Densidade = 7.8e3 kg/m3,
Tensao_de_escoamento = 250; %N/m2)

% MatElem, matriz de barras
%               Num    N1     N2     Seccion  Material
MatElementos=[ 1  1  2  1 1
               2  2  3  2 1];MatElementos=MatElementos(:,2:end);
    % Numero de barras
    NumElementos = size(MatElementos,1);

% Numero de estados de carregamento
NumEstCarga = 1;

% MatCondCont, matriz de condi��es de contorno
             %Num   Tx Ty Tz Vx Vy Vz  (si esta restringido en alguna direccion Tx, Ty, Tz=0)
MatCondBorde=[ 1 0 0 0  0.0  0.0     0.0
               2 1 1 0  0.0 -200e-3  0.0   ];
    MatCondBordeR = MatCondBorde(:,5:7);
    MatCondBordeI = MatCondBorde(:,2:4);
        % Numero de condiciones de contorno
        NumCondBorde = size(MatCondBorde,1);

% MatCondNo, matriz de condi��es de contorno em n�s
%                    Num     No     Estado_de_carregamento
%                    Condi��o_de_borde
MatCondBordeNodos=[ 1  1  1 1
                    2  3  1 1
                    3  2  1 2];MatCondBordeNodos=MatCondBordeNodos(:,2:end);
    % Numero de condi��es em n�s
    NumCondBordeNodos = size(MatCondBordeNodos,1);

% MatRestrCol, matriz de restri��es de colinearidade
%              Num   No_central  No_1   No_2
MatResCol=[0 0 0 0];MatResCol=MatResCol(:,2:4);
    % Numero de restri��es de colinearidade
    NumResCol = 0;

% MatRestrDesp, matriz de restri��es de deslocamento
%            Num    No    Grau_de_liberdade Tmin Tmax Dmin Dmax
MatResDes=[1 13 1 1 1 80e-3 80e-3
           2 13 2 1 1 80e-3 80e-3
           3 13 3 1 1 1e-3  1e-3 ];
    MatResDesR = MatResDes(:,6:7);
    MatResDesI = MatResDes(:,2:5);
        %Numero de restri��es de deslocamento
        NumResDes = size(MatResDes,1);

% Numero de variables sin variables alpha.
NumVar = NumVarSec + NumVarPos; % + NumResCol;


P_analysis_init


% P_Plot

