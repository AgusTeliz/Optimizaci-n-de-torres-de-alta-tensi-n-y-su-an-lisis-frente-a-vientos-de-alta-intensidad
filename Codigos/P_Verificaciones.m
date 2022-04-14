%% P_verificaciones



%% Estados de carga reales para la fuerza de masa
P_MountMM

D_m = diag(M)*3/2;

DD_F = -D_m*9.8/1000; % Fuerza en kN
DD_F = DD_F(3:3:end);
DD_F([77-4  78-4  111-4 112-4 157-4 158-4 183-4 184-4]) = DD_F([77-4  78-4  111-4 112-4 157-4 158-4 183-4 184-4]) +Dc;% Para sacar la fuerza de los cables

VecF(3:3:end,:)= [DD_F DD_F DD_F DD_F DD_F DD_F DD_F];

%% Sigma con estados de carga reales

U = VecU;

%% Verificaciones Fluencia y pandeo


Fy = 250e-3; % 250 MPa

Vec_ensayo = ((NumElementos)*(Ensayo-1)+1:NumElementos*Ensayo)';
Sigma_Est = Sigma(Vec_ensayo);

F_elem = zeros(NumElementos,1); %%% Cuidado con las unidades
FS     = zeros(NumElementos,1);
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

        DX = (X2 - X1)/3;
        DY = (Y2 - Y1)/3;
        DZ = (Z2 - Z1)/3;

        LL = sqrt(DX*DX + DY*DY + DZ*DZ)*1000;
        LI = CD1/LL;

        XL = LI*DX;
        YL = LI*DY;
        ZL = LI*DZ;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%  Propiedades geométricas del elemento y propiedades del material  %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        VarS = MatElementos(Elem,VS);
        Mate = MatElementos(Elem,Ma);

        Aele = MatVarSecR(VarS,Ax);
        Eele = MatMaterialesR(Mate,EE);
        
%         Sigma_elem = F_elem(Elem)/Aele;
        Sigma_elem = Sigma_Est(Elem);
        
        if Sigma_elem >= 0 
            
            FS(Elem) = SigmaMax(Elem)/ Sigma_elem;
            
        else
            Num_A_elem = find(Area == Aele);%%%%%%%%%%
            
            
            if Elem == 210
                paro=1;
            end
            ra = Rad_giro(Num_A_elem);
            
            if LL/ra <= 75              %% Calcula la esbeltez
                lambda =  60+0.8*LL/ra;
                
%                 LL_ra_print = num2str(round(LL/ra,1));
%                 lambda_print    = num2str(round(lambda,2));
%                 
%                 fprintf('|      '),fprintf(LL_ra_print),fprintf('        |   '), fprintf(lambda_print),fprintf('    |  '),fprintf('\n')

                
            else
                lambda =  45+LL/ra;

            end

            Fe = pi^2*Eele/lambda^2;
            
            
            if lambda <= 4.71*sqrt(Eele/Fy)
                
                Fcr = -(0.658^(Fy/Fe))*Fy;
                
            else
                
                Fcr = -0.877*Fe;
            end
            
            Fcr = Fcr/1.67;  % Factor de seguridad
            
            FS(Elem) = Fcr/Sigma_elem;
            
       end

    end
    
    Ensayo_print = num2str(Ensayo);
    FS_print     = num2str(round(min(FS),3));
    
    fprintf('|      '),fprintf('Ensayo '),fprintf(Ensayo_print),fprintf('        |   '), fprintf(FS_print),fprintf('    |  '),fprintf('\n')






