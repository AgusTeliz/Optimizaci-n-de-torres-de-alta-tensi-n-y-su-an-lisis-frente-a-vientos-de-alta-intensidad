%% Nod_Brazos_fijos

%%
Nodos_Fijos = [78 112 158 183]; % Al fijar uno se fija su simetrico
for i = Nodos_Fijos
    fix_x = MatNodos(i,2);
    fix_y = MatNodos(i,3);
    fix_z = MatNodos(i,4);
    
    % fijo desplazamiento en x e y
    MatVarPos(fix_x,5) = MatVarPos(fix_x,2);
%     MatVarPos(fix_x,6) = MatVarPos(fix_x,2);
    
    % fijo desplazamiento en z
    MatVarPos(fix_z,5) = MatVarPos(fix_z,2);
%     MatVarPos(fix_z,6) = MatVarPos(fix_z,2);
    
end
    