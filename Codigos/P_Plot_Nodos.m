%% P_Plot_Nodos

for i = 1:Num_N4
  
    Nod = N_4(i); % Se supone que Nod1 < Nod2 (Ver: Cambio orden en Lectura)
    
    Sis = MatNodos(Nod,Si);
    
    Co1X = MatSisCoord(Sis,XX);
    Co1Y = MatSisCoord(Sis,YY);
    Co1Z = MatSisCoord(Sis,ZZ);
    
    Var1X = MatNodos(Nod,VX);
    Var1Y = MatNodos(Nod,VY);
    Var1Z = MatNodos(Nod,VZ);
    
    X1 = Co1X*MatVarPosR(Var1X,Co);
    Y1 = Co1Y*MatVarPosR(Var1Y,Co);
    Z1 = Co1Z*MatVarPosR(Var1Z,Co);

  
    figure(1)
    hold on
    
    plot3([X1],[Y1],[Z1],'r*','linewidth',2)

    hold off
end