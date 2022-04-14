%---------------        P_Plot_U       ----------------------------
%------------------------------------------------------------------

%    u = [MatVarPosR(1:NumVarPos,1);MatVarSecR(1:NumVarSec,1)];

% Escala = input('Escala = ');
Modo = input('Modo = ');

K = F_MountMK(X0);
P_MountMM;

P_Plot

M = M/1000; % 1000kg = ton
% K = K*1000 ;

[V,D] = eig(K,M,'chol');

lambda_2 = D(Modo,Modo);
Fr = sqrt(lambda_2)/(2*pi)
T = 1/Fr
v = V(:,Modo);
v = v/norm(v);
VecU(1:NumGrLib) = v;

Escala = 3/max(abs(v));


Ensayo = 1;

for NodG = 1 : NumNodos
    GrGN = MatGrLib(NodG,DG1:DG3);
    NGLN = MatGrLib(NodG,NDL);
    GrLN = MatGrLib(NodG,DL1:DL3);
    
    for Est = 1:NumEstCarga
        for GrL = 1:NGLN
            MatUo(NodG,GrLN(GrL),Est) = VecU((Est-1)*NumGrLib+GrGN(GrLN(GrL)));
        end
    end
end


    Uplot=MatUo*Escala;
%%%%%%%%%%  Plot Desplazamientos %%%%%%%%%%%

for Elem=1:NumElementos
  
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

    X1 = Co1X*MatVarPosR(Var1X,Co)+Uplot(Nod1,1,Ensayo);
    Y1 = Co1Y*MatVarPosR(Var1Y,Co)+Uplot(Nod1,2,Ensayo);

    X2 = Co2X*MatVarPosR(Var2X,Co)+Uplot(Nod2,1,Ensayo);
    Y2 = Co2Y*MatVarPosR(Var2Y,Co)+Uplot(Nod2,2,Ensayo);

    
    if size(Uplot,2)>2
        Z1 = Co1Z*MatVarPosR(Var1Z,Co)+Uplot(Nod1,3,Ensayo);
        Z2 = Co2Z*MatVarPosR(Var2Z,Co)+Uplot(Nod2,3,Ensayo);
    end   

    figure(1)
    hold on
    plot3([X1 X2],[Y1 Y2],[Z1 Z2],'m')
    hold off
end  

axis([-12 12 -12 12 0 48])

