xNodo = 7.938125;
yNodo = 0;
zNodo = 31.755312499999999;
sist_coord = 1;
sist_coord1 = 1;
sist_coord2 = 1;

Pos_xNodo = find (MatVarPosTot(:,2) == xNodo)
Pos_yNodo = find (MatVarPosTot(:,2) == yNodo)
Pos_zNodo = find (MatVarPosTot(:,2) == zNodo)

X_Nodo = find(MatNodos(:,1) == Pos_xNodo & ...
              MatNodos(:,2) == Pos_yNodo & ...
              MatNodos(:,3) == Pos_zNodo & ...
              MatNodos(:,4) == sist_coord)
%               (MatNodos(:,4) == sist_coord1 | MatNodos(:,4) == sist_coord2))
%                Para encontrar dos nodos al mismo tiempo con diferente coord
