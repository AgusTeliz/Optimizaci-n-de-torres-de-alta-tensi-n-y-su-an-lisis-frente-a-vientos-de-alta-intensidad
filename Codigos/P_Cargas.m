%%     P_Cargas  Estados de Carga        %%

% Combinaciones 
% 1: D
% 2: D + Lr
% 3: D + 0.75Lr + 0.75W
% 4: 0.6D +W
% 5: D +W

% Combinaciones (Lr=0)
% 1: D
% 2: D + 0.75W
% 3: 0.6D + W
% 4: D + W



Vd = 43.9  ; % m/s     o    37.5 m/s
Kt = 1     ;
Kd = 0.96  ;
Kk = 1.28  ;

% Kz_1 = 1.012 ;
% Kz_2 = 1.098 ;
% Kz_3 = 1.126 ;
% Kz_4 = 1.162 ;

altura_1 = 13; % m  Figura de altura y Kz
altura_2 = 26; % m
altura_3 = 33; % m
altura_4 = 44; % m





v_c = Kt*Kd*Kk*Vd  ;
rho_air  = 1.2 ;% kg/m^3
q_a = 0.5 * rho_air * v_c.^2 * 1e-3; % Carga (KPa) Falta multiplicar por K_z^2

%% Modulo 1

A_proy_enc  = 78.6;% m2 Area solida proyectada (medida en CAD)
A_Proy_real =  8.7;

delta = A_Proy_real/A_proy_enc; % Aprox 0.2
C_d   = (delta - 0.1)/(0.2-0.1)*(2.9-3.4)+3.4;
Kz_1  = (altura_1/10)^0.1;

q_M1 = (q_a*Kz_1^2) * C_d; % kN
F_M1 = q_M1 * A_Proy_real;

NumNodos_mod1 = 32; % 32 nodos en el primer modulo

W_M1 = F_M1/NumNodos_mod1 ; % kN
N_M1 = (5:NumNodos_mod1)';
Num_M1 = size(N_M1,1);

%% Modulo 2

A_proy_enc  = 63.2;% m2 Area solida proyectada (medida en CAD)
A_Proy_real =  8.1;

delta = A_Proy_real/A_proy_enc; % Aprox 0.2
C_d   = (delta - 0.1)/(0.2-0.1)*(2.9-3.4)+3.4;
Kz_2  = (altura_2/10)^0.1;

q_M2 = (q_a*Kz_2^2) * C_d; % kN
F_M2 = q_M2 * A_Proy_real;

NumNodos_mod2 = 44; % 32 nodos en el primer modulo

W_M2 = F_M2/NumNodos_mod2; % kN
N_M2 = (NumNodos_mod1+1:NumNodos_mod1+NumNodos_mod2)';
Num_M2 = size(N_M2,1);

%% Modulo 3

A_proy_enc  = 55.7;% m2 Area solida proyectada (medida en CAD)
A_Proy_real =  9.1;

delta = A_Proy_real/A_proy_enc; % Aprox 0.2
C_d   = (delta - 0.1)/(0.2-0.1)*(2.9-3.4)+3.4;
Kz_3  = (altura_3/10)^0.1;

q_M3 = (q_a*Kz_3^2) * C_d ;% kN
F_M3 = q_M3 * A_Proy_real ;

NumNodos_mod3 = 44+4; % brazos (77 78 111 112 )

W_M3 = F_M3/NumNodos_mod3 ; % kN

N_M3 = (NumNodos_mod1+NumNodos_mod2+1:NumNodos_mod1+NumNodos_mod2+NumNodos_mod3)';
Num_M3 = size(N_M3,1);

%% Modulo 4

A_proy_enc  = 36.1;% m2 Area solida proyectada (medida en CAD)
A_Proy_real =  7.1;
Kz_4  = (altura_4/10)^0.1;

delta = A_Proy_real/A_proy_enc; % Aprox 0.2
C_d   = (delta - 0.1)/(0.2-0.1)*(2.9-3.4)+3.4;

q_M4 = (q_a*Kz_4^2) * C_d ; % kN
F_M4 = q_M4* A_Proy_real ;

NumNodos_mod4 = 64+4; % brazos (157 158 183 184)

W_M4 = F_M4/NumNodos_mod4 ; % kN
N_M4 = (NumNodos_mod1+NumNodos_mod2+NumNodos_mod3+1:NumNodos_mod1+NumNodos_mod2+NumNodos_mod3+NumNodos_mod4)';
Num_M4 = size(N_M4,1);






%% Fuerza de masa constante en la op

D1 = -3.25 ; %MatM(9,9)*3/2*9.8/1000;
D2 = -2.50 ; %MatM(41,41)*3/2*9.8/1000;
D3 = -2.50;
D4 = -2.50  ;


% D1 = -1.05  ; %MatM(9,9)*3/2*9.8/1000;
% D2 = -0.74 ; %MatM(41,41)*3/2*9.8/1000;
% D3 = -0.58 ;
% D4 = -0.52 ;




%%   Números de estados de carga y Matriz de condición de borde   %%
    % Combinaciones (Lr=0)
    % MatCondBorde, matriz de condiciones de Borde
    % 1: D
    % 2: D + 0.75W
    % 3: 0.6D + W
    % 4: D + W
    %                   Num Tx Ty Tz   Vx       Vy      Vz    (si esta restringido en alguna direccion Tx, Ty, Tz=0)
        MatCondBorde = [ 1  0  0  0  0.0         0.0        0.0
            
                         2  1  1  1  0.0         0.0        D1
                         3  1  1  1  0.0         0.0        D2
                         4  1  1  1  0.0         0.0        D3
                         5  1  1  1  0.0         0.0        D4
                         6  1  1  1  0.75*W_M1   0.0        D1
                         7  1  1  1  0.75*W_M2   0.0        D2
                         8  1  1  1  0.75*W_M3   0.0        D3
                         9  1  1  1  0.75*W_M4   0.0        D4
                        10  1  1  1  W_M1        0.0        0.6*D1
                        11  1  1  1  W_M2        0.0        0.6*D2 
                        12  1  1  1  W_M3        0.0        0.6*D3
                        13  1  1  1  W_M4        0.0        0.6*D4
                        14  1  1  1  W_M1        0.0        D1
                        15  1  1  1  W_M2        0.0        D2
                        16  1  1  1  W_M3        0.0        D3
                        17  1  1  1  W_M4        0.0        D4
                        
                        18  1  1  1  0.0         0.75*W_M1  D1
                        19  1  1  1  0.0         0.75*W_M2  D2
                        20  1  1  1  0.0         0.75*W_M3  D3
                        21  1  1  1  0.0         0.75*W_M4  D4
                        22  1  1  1  0.0         W_M1       0.6*D1
                        23  1  1  1  0.0         W_M2       0.6*D2 
                        24  1  1  1  0.0         W_M3       0.6*D3
                        25  1  1  1  0.0         W_M4       0.6*D4
                        26  1  1  1  0.0         W_M1       D1
                        27  1  1  1  0.0         W_M2       D2
                        28  1  1  1  0.0         W_M3       D3
                        29  1  1  1  0.0         W_M4       D4      ];


                     
                     
 %%   Matriz de condición de borde en nodos   %%%
     % (Nodos Fijos)
     % MatCondNo, matriz de condiciones de contorno en nodos
     %                   Num Nodo Numero_de_ensayo Condicion_de_contorno
     %                                                     (MatConBorde)
     MatCondBordeNodos = [ 1             1               1
                           2             1               1
                           3             1               1
                           4             1               1 ];
%% Estado de carga 1: D
NumNodosTot = 192;
%            todos_los_nodos_libres estado_de_carga(1)     Fuerza_externa
Estado_1 = [  N_M1                ones(Num_M1,1)*1           ones(Num_M1,1)*2
              N_M2                ones(Num_M2,1)*1           ones(Num_M2,1)*3
              N_M3                ones(Num_M3,1)*1           ones(Num_M3,1)*4
              N_M4                ones(Num_M4,1)*1           ones(Num_M4,1)*5]; 
% Estado_1 = [];

%% Estado de carga 2: D + 0.75W_x
%             todos_los_nodos     estado_de_carga(2)         Fuerza_externa
Estado_2 = [  N_M1                ones(Num_M1,1)*2           ones(Num_M1,1)*6
              N_M2                ones(Num_M2,1)*2           ones(Num_M2,1)*7
              N_M3                ones(Num_M3,1)*2           ones(Num_M3,1)*8
              N_M4                ones(Num_M4,1)*2           ones(Num_M4,1)*9     ]; 
% Estado_2 = [];

%% Estado de carga 3: 0.6D + W_x
%             todos_los_nodos   estado_de_carga(3)    Fuerza_externa
Estado_3 =  [ N_M1                ones(Num_M1,1)*3           ones(Num_M1,1)*10
              N_M2                ones(Num_M2,1)*3           ones(Num_M2,1)*11
              N_M3                ones(Num_M3,1)*3           ones(Num_M3,1)*12
              N_M4                ones(Num_M4,1)*3           ones(Num_M4,1)*13     ];
% Estado_3 = [];

%% Estado de carga % 4: D + W_x
%             todos_los_nodos   estado_de_carga(4)    Fuerza_externa
Estado_4 =  [ N_M1                ones(Num_M1,1)*4           ones(Num_M1,1)*14
              N_M2                ones(Num_M2,1)*4           ones(Num_M2,1)*15
              N_M3                ones(Num_M3,1)*4           ones(Num_M3,1)*16
              N_M4                ones(Num_M4,1)*4           ones(Num_M4,1)*17     ];
% Estado_4 = [];

%% Estado de carga 5: D + 0.75W_y
%             todos_los_nodos   estado_de_carga(5)    Fuerza_externa
Estado_5 =  [ N_M1                ones(Num_M1,1)*5           ones(Num_M1,1)*18
              N_M2                ones(Num_M2,1)*5           ones(Num_M2,1)*19
              N_M3                ones(Num_M3,1)*5           ones(Num_M3,1)*20
              N_M4                ones(Num_M4,1)*5           ones(Num_M4,1)*21     ];
% Estado_5 = [];

%% Estado de carga 6: 0.6D + W_y
%             todos_los_nodos   estado_de_carga(6)    Fuerza_externa
Estado_6 = [  N_M1                ones(Num_M1,1)*6           ones(Num_M1,1)*22
              N_M2                ones(Num_M2,1)*6           ones(Num_M2,1)*23
              N_M3                ones(Num_M3,1)*6           ones(Num_M3,1)*24
              N_M4                ones(Num_M4,1)*6           ones(Num_M4,1)*25     ];
% Estado_6 = [];

%% Estado de carga % 7: D + W_y
%             todos_los_nodos   estado_de_carga()    Fuerza_externa
Estado_7 = [  N_M1                ones(Num_M1,1)*7           ones(Num_M1,1)*26
              N_M2                ones(Num_M2,1)*7           ones(Num_M2,1)*27
              N_M3                ones(Num_M3,1)*7           ones(Num_M3,1)*28
              N_M4                ones(Num_M4,1)*7           ones(Num_M4,1)*29     ];
% Estado_7 = [];

%% Ensamble de las matrices

MatCondBordeNodos = [MatCondBordeNodos
                     Estado_1
                     Estado_2
                     Estado_3
                     Estado_4
                     Estado_5
                     Estado_6
                     Estado_7          ];
                 
                 
%% Peso de los cables
Nodo_cables = [77; 78; 111; 112; 157; 158; 183; 184];
Dc = -400*2.002*9.8/1000; % 400m*2002kg/m*9.8m/s^2/1000N/kN

MatCondBorde = [MatCondBorde
                size(MatCondBorde,1)+1   1  1  1  0.0     0.0       Dc    ];
            
Peso_cables = [];
Cant_carg = max(MatCondBordeNodos(:,2)); % Agrega el peso del cable a los estados de carga existentes
for i = 1:Cant_carg
    Peso_cables = [Peso_cables
                   Nodo_cables         ones(size(Nodo_cables))*i           ones(size(Nodo_cables))*(MatCondBorde(end,1)) ];
end


MatCondBordeNodos = [MatCondBordeNodos
                     Peso_cables       ];

            
MatCondBordeNodos = [(1:size(MatCondBordeNodos,1))' MatCondBordeNodos];



























%%  Viejo pero puede servir


% 
% 
% 
% %%   Números de estados de carga y Matriz de condición de borde   %%
%     % MatCondBorde, matriz de condiciones de Borde
%     %                   Num Tx Ty Tz  Vx      Vy      Vz    (si esta restringido en alguna direccion Tx, Ty, Tz=0)
%         MatCondBorde = [ 1   0  0  0  0.0     0.0     0.0
%                          2   1  1  1  0.0     0.0     D
%                          3   1  1  1  0.0     0.0     0.6*D
%                          4   1  1  1  W       0.0     0.0
%                          5   1  1  1  0.0     W       0.0
%                          6   1  1  1  0.75*W  0.0     0.0
%                          7   1  1  1  0.0     0.75*W  0.0   ];
% 
% 
%                      
%                      
%  %%   Matriz de condición de borde en nodos   %%%
%      % (Nodos Fijos)
%      % MatCondNo, matriz de condiciones de contorno en nodos
%      %                   Num Nodo Numero_de_ensayo Condicion_de_contorno
%      %                                                     (MatConBorde)
%      MatCondBordeNodos = [ 1             1               1
%                            2             1               1
%                            3             1               1
%                            4             1               1 ];
% %% Estado de carga 1: D
% %            todos_los_nodos_libres estado_de_carga(1)     Fuerza_externa
% Estado_1 = [     (5:NumNodos)'       ones(NumNodos-4,1)    ones(NumNodos-4,1)*2];
% 
% %% Estado de carga 2: D + 0.75W_x
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_2_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*2  ones(NumNodos-4,1)*2];
% Estado_2_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*2  ones(NumNodos-4,1)*6];
% 
% Estado_2 = [Estado_2_D ; Estado_2_W];
% 
% %% Estado de carga 3: 0.6D + W_x
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_3_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*3  ones(NumNodos-4,1)*3];
% Estado_3_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*3  ones(NumNodos-4,1)*4];
% 
% Estado_3 = [Estado_3_D ; Estado_3_W];
% 
% %% Estado de carga % 4: D + W_x
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_4_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*4  ones(NumNodos-4,1)*2];
% Estado_4_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*4  ones(NumNodos-4,1)*4];
% 
% Estado_4 = [Estado_4_D ; Estado_4_W];
% 
% %% Estado de carga 5: D + 0.75W_y
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_5_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*5  ones(NumNodos-4,1)*2];
% Estado_5_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*5  ones(NumNodos-4,1)*7];
% 
% Estado_5 = [Estado_5_D ; Estado_5_W];
% 
% %% Estado de carga 6: 0.6D + W_y
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_6_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*6  ones(NumNodos-4,1)*3];
% Estado_6_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*6  ones(NumNodos-4,1)*5];
% 
% Estado_6 = [Estado_6_D ; Estado_6_W];
% 
% %% Estado de carga % 7: D + W_y
% %             todos_los_nodos   estado_de_carga(1)    Fuerza_externa
% Estado_7_D = [ (5:NumNodos)'    ones(NumNodos-4,1)*7  ones(NumNodos-4,1)*2];
% Estado_7_W = [ (5:NumNodos)'    ones(NumNodos-4,1)*7  ones(NumNodos-4,1)*5];
% 
% Estado_7 = [Estado_7_D ; Estado_7_W];
% 
% %% Ensamble de las matrices
% 
% MatCondBordeNodos = [MatCondBordeNodos
%                      Estado_1
%                      Estado_2
%                      Estado_3
%                      Estado_4
%                      Estado_5
%                      Estado_6
%                      Estado_7          ];
% 
% MatCondBordeNodos = [(1:size(MatCondBordeNodos,1))' MatCondBordeNodos];
% 
% 
