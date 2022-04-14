%---------------        P_Plot_U       ----------------------------
%------------------------------------------------------------------

%    u = [MatVarPosR(1:NumVarPos,1);MatVarSecR(1:NumVarSec,1)];

    Escala = input('Escala = ');
    Ensayo = input('Ensayo = ');

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
%% Ploteo torre desplomanda
% Vec_desp = load('Desp_InestGlob.txt');
% Giros = [2:6:1148 4:6:1150 6:6:1152];
% Vec_desp(Giros) = [];
% Vec_desp_x = Vec_desp(1:3:end);
% Vec_desp_y = Vec_desp(2:3:end);
% Vec_desp_z = Vec_desp(3:3:end);
% MatUo (:,1:3,2) = [Vec_desp_x Vec_desp_y Vec_desp_z];
    
%%
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

view([1 1/2 1 ])

axis equal
