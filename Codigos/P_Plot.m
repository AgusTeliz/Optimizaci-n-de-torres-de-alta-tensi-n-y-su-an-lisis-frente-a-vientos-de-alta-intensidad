%---------------        P_Plot       ------------------------------
%------------------------------------------------------------------
grosor_base = 0.1;
Amax = max(MatVarSecR(:,2));
% Amax = max(x(NumVarPos+NumVarPosFix+1:end));



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
    
    X1 = Co1X*MatVarPosR(Var1X,Co);
    Y1 = Co1Y*MatVarPosR(Var1Y,Co);
    Z1 = Co1Z*MatVarPosR(Var1Z,Co);
    X2 = Co2X*MatVarPosR(Var2X,Co);
    Y2 = Co2Y*MatVarPosR(Var2Y,Co);
    Z2 = Co2Z*MatVarPosR(Var2Z,Co);
    
    VarS = MatElementos(Elem,VS);
    Aele = MatVarSecR(VarS,Ax);
    
    figure(1)
    hold on
    
    if (Aele == MatVarSecR(VarS,Ax+1) && Aele == MatVarSecR(VarS,Ax+2))
        plot3([X1 X2],[Y1 Y2],[Z1 Z2],'k', 'linewidth', grosor_base * sqrt(Aele/Amax) )
    else if (Aele < 1.1* MatVarSecR(VarS,Ax+1))
            plot3([X1 X2],[Y1 Y2],[Z1 Z2],'k', 'linewidth', grosor_base * sqrt(Aele/Amax) )
        else
            plot3([X1 X2],[Y1 Y2],[Z1 Z2],'k', 'linewidth', grosor_base * sqrt(Aele/Amax) )
        end
    end
    hold off
end
axis equal

view([1 1/2 1 ])
