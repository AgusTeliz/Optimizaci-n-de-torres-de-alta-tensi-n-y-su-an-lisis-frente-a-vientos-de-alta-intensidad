Pos_x = MatVarPosTot(MatNodos(:,1),2).*MatSisCoord(MatNodos(:,end),1);
Pos_y = MatVarPosTot(MatNodos(:,2),2).*MatSisCoord(MatNodos(:,end),2);
Pos_z = MatVarPosTot(MatNodos(:,3),2).*MatSisCoord(MatNodos(:,end),3);

MatNodos_xyz = [Pos_x, Pos_y, Pos_z];
MatNodos_xyz_cell = mat2cell(MatNodos_xyz,[ones(1,size(MatNodos_xyz,1))]);


Conec_Nod = [zeros(NumNodos,1) ones(NumNodos,1) ones(NumNodos,1) zeros(NumNodos,1) [1;1;1;1;zeros(NumNodos-4,1)] (1:NumNodos)'];
% Conec_Nod_cell = mat2cell(Conec_Nod,[ones(1,size(Conec_Nod,1))]);

Conec_elem = [ones(NumElementos,1) ones(NumElementos,1)*2 zeros(NumElementos,1) ones(NumElementos,1) zeros(NumElementos,1) MatElementos(:,1:2)];
% Conec_elem_cell = mat2cell(Conec_elem,[ones(1,size(Conec_elem,1))]);

% Conec = [Conec_Nod;Conec_elem];
% Conec_cell = [Conec_Nod_cell;Conec_elem_cell];

dlmwrite('MatNodos.txt',MatNodos_xyz)
dlmwrite('Conec_Nod.txt',Conec_Nod)
dlmwrite('Conec_elem.txt',Conec_elem)

dlmwrite('Vec_sec.txt',MatSecciones)
