%%        P_Plot_F       %% 
    Ensayo = input('Ensayo = ');

P_Plot

Cargas = find( MatCondBordeNodos(:,2) == Ensayo &...
               MatCondBordeNodos(:,3) ~= 1          );
           

Nodos_cargas = MatCondBordeNodos(Cargas,1);

pos_x = MatVarPosTot(MatNodos(Nodos_cargas,1),2).*MatSisCoord(MatNodos(Nodos_cargas,4),1);
pos_y = MatVarPosTot(MatNodos(Nodos_cargas,2),2).*MatSisCoord(MatNodos(Nodos_cargas,4),2);
pos_z = MatVarPosTot(MatNodos(Nodos_cargas,3),2).*MatSisCoord(MatNodos(Nodos_cargas,4),3);

Fx = MatCondBorde(MatCondBordeNodos(Cargas,end),5);
Fy = MatCondBorde(MatCondBordeNodos(Cargas,end),6);
Fz = MatCondBorde(MatCondBordeNodos(Cargas,end),7);

hold on
quiver3(pos_x(1:end-8),pos_y(1:end-8),pos_z(1:end-8),Fx(1:end-8),Fy(1:end-8),Fz(1:end-8),'b')
quiver3(pos_x(end-7:end),pos_y(end-7:end),pos_z(end-7:end),Fx(end-7:end),Fy(end-7:end),Fz(end-7:end),'r')

view([1,1,1])
