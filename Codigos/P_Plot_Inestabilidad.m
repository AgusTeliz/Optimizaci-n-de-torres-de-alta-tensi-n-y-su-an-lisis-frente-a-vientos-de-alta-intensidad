%---------------        P_Plot_U       ----------------------------
%------------------------------------------------------------------
P_Mount;
P_MountMM


if NumEstCarga > 1
    Ensayo = input('Ensayo = ');
else
    Ensayo=1;
end
P_MountMG;




[V,D] = eig(K,G,'chol');
lambda = diag(D);     %%%  ??

l = lambda(lambda>0);
a = (1:length(lambda));
a = a(lambda>0);
[val,pos] = min(l);
Modo = a(pos);
v = V(:,Modo);
v = v/norm(v);
VecU(1:NumGrLib) = v;
val
Escala = 5/max(VecU);




P_Plot;


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


axis equal
