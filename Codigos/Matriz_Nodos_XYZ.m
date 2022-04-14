%% Matriz_Nodos_XYZ

% Posicion de los nodos en x
    
    Nod_X = MatNodos(:,1);
    Nod_X = MatVarPosR(Nod_X,1);
    Nod_X = Nod_X.* MatSisCoord(MatNodos(:,4),1);
    
    Nod_Y = MatNodos(:,2);
    Nod_Y = MatVarPosR(Nod_Y,1);
    Nod_Y = Nod_Y.* MatSisCoord(MatNodos(:,4),2);
    
    Nod_Z = MatNodos(:,3);
    Nod_Z = MatVarPosR(Nod_Z,1);
    Nod_Z = Nod_Z.* MatSisCoord(MatNodos(:,4),3);

% Junto las matrices

    Mat_Nod_XYZ = [Nod_X Nod_Y Nod_Z];
    
% Ploteo
    P_Plot
    figure(1)    
    hold on
    plot3(Mat_Nod_XYZ(:,1),Mat_Nod_XYZ(:,2),Mat_Nod_XYZ(:,3),'r*')