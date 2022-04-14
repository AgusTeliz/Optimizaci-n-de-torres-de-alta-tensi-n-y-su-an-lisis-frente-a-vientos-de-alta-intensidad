
%%%%   Diseño de la Torre   %%%

P_Global  %//  Define matrices globales


%%   Matriz de Distancias   %%
    % MatVarPos, matriz de posiciones variables
    %             Num   Valor (mm)     Tmin    Tmax  Pmin        Pmax
        Analisis_lineas
        
    % MatVarPosFix, matriz de posiciones fijas
    %                    Num                 Valor
         MatVarPosFix = [ MatVarPos(end,1)+1      0   ]; 
        
    % MatVarPosTot, matriz con todas las posiciones posiciones 
        MatVarPosTot = [MatVarPos ; [MatVarPosFix zeros(size(MatVarPosFix,1),4)]];
    
        
%% Relacione entre la inercia y el area
    % Paso previo para generar la funcion F_Inercia_A
        P_Area_Inercia
    
%%   Matriz de Secciones   %%
    % MatVarSec, matriz de seccion variable (1e-4 metro cuadrado = 1 cm cuadrado)
    %                   Num    Area    Tmin   Tmax   Amin   Amax  GrD
    %      MatVarSec = [ 1     1e-1       1      1      1e-2   10   1 ]; %Ejemplo

    % MatSecFix, matriz de secciones fijas
    %                   Num   Area  (1e-4 metro cuadrado = 1 cm cuadrado)
    %     MatVarSecFix = [ 7   1e-1]; % Ejemplo
         Analisis_MatVarSec


%%   Matriz de sistemas de coordenadas   %%
    % MatSisCoord, matriz de sistemas de coordenadas
        %              Num  X  Y  Z
        MatSisCoord = [ 1   1  1  1
                        2  -1  1  1
                        3  -1 -1  1
                        4   1 -1  1 ];


%%   Matriz de Nodos %%
    % MatNodos, matriz de coordenadas nodales
        Mat_nodos_paper

        
%% Fijar Nodos de los brazos
        P_Nod_Brazos_fijos
        
        
%%   Matriz de Materiales   %%
    % MatMat, matriz de parametros de los materiales
        %                Num   E   P  D(kg/mm3)  Costo    Tac  Tat  tac   tat
        MatMateriales = [ 1   200 0.3  7.8/1e6    1.0    1    1  0.250/1.67/FS_opcional  0.250/1.67/FS_opcional];  % Unidades en MPa


%%   Matriz de Elementos   %%
    % MatElementos, matriz de barras
        Mat_Elem_paper

%% Estados de Carga

P_Cargas

% %   Números de estados de carga y Matriz de condición de borde   %%
%     % MatCondBorde, matriz de condiciones de Borde
%     %                   Num Tx Ty Tz  Vx      Vy        Vz    (si esta restringido en alguna direccion Tx, Ty, Tz=0)
%         MatCondBorde = [ 1   0  0  0  0.0      0.0     0.0
%                          2   1  1  1  3.80     0.0     -16.90
%                          3   1  1  1  26.40    0.0     -77.00 
%                          4   1  1  1  10.60    0.0      -1.65
%                          5   1  1  1  12.70    0.0      -2.85
%                          6   1  1  1  19.80    0.0     -57.75
%                          7   1  1  1  25.65/sqrt(2) 0  -25.65/sqrt(2)];
% 
% 
%  %   Matriz de condición de borde en nodos   %%%
%      % MatCondNo, matriz de condiciones de contorno en nodos
%      %                       Num Nodo Numero_de_ensayo Condicion_de_contorno
%      %                                                      (MatConBorde)
%         MatCondBordeNodos = [ 1   1    1 1
%                               2   2    1 1
%                               3   3    1 1
%                               4   4    1 1
%                               5   183  1 2
%                               6   184  1 2
%                               7   158  1 3
%                               8   157  1 3
%                               9   111  1 3
%                               10  112  1 3
%                               11  78   1 3
%                               12  77   1 3
%                               13  183  2 4
%                               14  184  2 5
%                               15  158  2 6
%                               16  157  2 6
%                               17  111  2 6
%                               18  112  2 6
%                               19  78   2 6
%                               20  77   2 6
%                               21  183  2 7    ];



%%   Matriz de Restricción de colinealidad   %%
    % MatRestrCol, matriz de restricciones de colinealidad
    %               Num No_central  No_1   No_2
        Colinealidad
    %     MatResCol = [1 41 45 46];


%%   Matriz de Restricción de dislocamiento   %%%
    % MatRestrDesp, matriz de restricciones de dislocamento
    %              Num No Grau_de_liberdade Tmin Tmax Dmin Dmax
        MatResDes = [1 13 1 1 1 80e-3 80e-3
                     2 13 2 1 1 80e-3 80e-3
                     3 13 3 1 1  1e-3  1e-3 ];








