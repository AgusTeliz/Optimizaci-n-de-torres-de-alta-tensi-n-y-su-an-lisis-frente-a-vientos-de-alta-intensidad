close all
clear
clc

P_Global

% MatVarSec, matriz das vari�veis de se��o (1e-4 metro quadrado = 1 cm quadrado)
%            Num    Area    Tmin   Tmax   Amin   Amax  GrD
MatVarSec = [ 1 1e-1 1 1 1e-6 2e-1 1
              2 1e-1 1 1 1e-6 2e-1 1
              3 1e-1 1 1 1e-6 2e-1 1
              4 1e-1 1 1 1e-6 2e-1 1
              5 1e-1 1 1 1e-6 2e-1 1
              6 1e-1 1 1 1e-6 2e-1 1 ];
% MatSecFix, matriz das se��es fixas
%               Num   Area  (1e-4 metro quadrado = 1 cm quadrado)
MatVarSecFix = [ 7   1e-4
                 8   1e-4];
    MatVarSecR = [MatVarSec(:,[2,5,6]) ; MatVarSecFix(:,[2,2,2])];
    MatVarSecI =  MatVarSec(:,3:4);
        % Numero de variables de seccion transversal de las barras
        NumVarSec = size(MatVarSec,1);    
        % N�mero de se��es fixas
        NumVarSecFix = size(MatVarSecFix,1);
    
% MatVarPos, matriz das vari�veis de posi��o
%            Num   Valor  Tmin  Tmax  Pmin  Pmax
MatVarPos=[ 1   0.45  1    1    0.1    2.0
            2   0.45  1    1    0.1    2.0
            3   0.45  1    1    0.1    1.0
            4   0.45  1    1    0.1    2.0
            5   0.45  1    1    0.1    2.0
            6   0.45  1    1    0.1    2.0
            7   3.0   1    1    2.3    3.5
            8   2.4   1    1    2.0    3.5
            9   0.9   1    1    0.6    1.5];

%            Num    Valor
MatVarPosFix=[ 10 0.0
               11 2.0
               12 1.5]; 
    MatVarPosR = [MatVarPos(:,[2 5 6]);  MatVarPosFix(:,[2 2 2])];         
    MatVarPosI = MatVarPos(:,3:4);
        % Numero de variables de posicion
        NumVarPos = size(MatVarPos,1);
        % Numero de posicoines fixas
        NumVarPosFix = size(MatVarPosFix,1);
    
% MatGrDisc, matriz dos grupos de se��es transversais discretas
%            NumGr    NumVal
MatGrDisc = [1        4     ];
    % Numero de grupos de secciones transversais discretas
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
%           Num   Cx    Cy    Cz    Sistema
MatNodos=[1  1  2  10 1
          2  1  2  10 2
          3  1  2  10 3
          4  1  2  10 4
          5  3  4   9 1
          6  3  4   9 2
          7  3  4   9 3
          8  3  4   9 4
          9  5  6  11 1
          10 5  6  11 2
          11 5  6  11 3
          12 5  6  11 4
          13 12 10 8  2
          14 10 10 7  1
          15 12 10 8  1];MatNodos=MatNodos(:,2:end);
        % Numero de n�s
        NumNodos = size(MatNodos,1);

% MatMat, matriz de par�metros dos materiais
%             Num   E     P   D   C  Tac  Tat tac  tat
MatMateriales=[1   200e9 0.3 7.8 1.0  1    1  250  250];
    MatMaterialesR = MatMateriales(:,[2 3 4 5 8 9]);
    MatMaterialesI = MatMateriales(:,6:7);
        % Numero de materiais
        NumMateriales = size(MatMateriales,1);

% Material -> Acero ASTM A36 (E = 200e6 N/m2, Densidade = 7.8e3 kg/m3,
Tensao_de_escoamento = 250; %N/m2)

% MatElem, matriz de barras
%               Num    N1     N2     Se��o  Material
MatElementos = [1  1  5  1 1
                2  2  6  1 1
                3  3  7  1 1
                4  4  8  1 1
                5  5  9  2 1
                6  6  10 2 1
                7  7  11 2 1
                8  8  12 2 1
                9  5  6  3 1
                10 6  7  3 1
                11 7  8  3 1
                12 5  8  3 1
                13 9  10 4 1
                14 10 11 4 1
                15 11 12 4 1
                16 9  12 4 1
                17 4  5  7 1
                18 1  8  7 1
                19 1  6  7 1
                20 2  5  7 1
                21 2  7  7 1
                22 3  6  7 1
                23 3  8  7 1
                24 4  7  7 1
                25 8  9  8 1
                26 5  12 8 1
                27 5  10 8 1
                28 6  9  8 1
                29 6  11 8 1
                30 7  10 8 1
                31 7  12 8 1
                32 8  11 8 1
                33 11 13 5 1
                34 10 13 5 1
                35 13 14 5 1
                36 12 15 5 1
                37 9  15 5 1
                38 14 15 5 1
                39 11 14 6 1
                40 10 14 6 1
                41 12 14 6 1
                42 9  14 6 1]; MatElementos = MatElementos(:,2:end);
    % Numero de barras
    NumElementos = size(MatElementos,1);

% Numero de estados de carregamento
NumEstCarga =3;

% MatCondCont, matriz de condi��es de contorno
             %Num Tx  Ty Tz Vx      Vy        Vz    (si esta restringido en alguna direccion Tx, Ty, Tz=0)
MatCondBorde=[ 1   0  0  0  0.0     0.0       0.0
               2   1  1  1  0.0     0.0      -200.0e-3
               3   1  1  1  0.0     160.0e-3 -100.0e-3
               4   1  1  1 -10.0e-3 0.0       0.0     ];
    MatCondBordeR = MatCondBorde(:,5:7);
    MatCondBordeI = MatCondBorde(:,2:4);
        % Numero de condi��es de contorno
        NumCondBorde = size(MatCondBorde,1);

% MatCondNo, matriz de condiciones de contorno en nodos
%                    Num     Nodo     Estado_de_cargamento Condicion_de_contorno
MatCondBordeNodos = [ 1  1  1 1
                      2  2  1 1
                      3  3  1 1
                      4  4  1 1
                      5  13 1 2
                      6  15 1 2
                      7  13 2 3
                      8  1  3 4
                      9  4  3 4
                      10 5  3 4
                      11 8  3 4
                      12 9  3 4
                      13 12 3 4
                      14 15 3 4
                      15 14 3 4];MatCondBordeNodos=MatCondBordeNodos(:,2:end);
    % Numero de condi��es em n�s
    NumCondBordeNodos = size(MatCondBordeNodos,1);

% MatRestrCol, matriz de restri��es de colinearidade
%              Num   No_central  No_1   No_2
MatResCol=[1 5 1 9 
           2 6 2 10];MatResCol=MatResCol(:,2:4);
    % Numero de restri��es de colinearidade
    NumResCol = 2;

% MatRestrDesp, matriz de restri��es de deslocamento
%            Num    No    Grau_de_liberdade Tmin Tmax Dmin Dmax
MatResDes = [1 13 1 1 1 80e-3 80e-3
             2 13 2 1 1 80e-3 80e-3
             3 13 3 1 1  1e-3  1e-3 ];
    MatResDesR = MatResDes(:,6:7);
    MatResDesI = MatResDes(:,2:5);
        %Numero de restri��es de deslocamento
        NumResDes = size(MatResDes,1);

% Numero de variables sin variables alpha.
NumVar = NumVarSec + NumVarPos; % + NumResCol;


P_analysis_init


% P_Plot







