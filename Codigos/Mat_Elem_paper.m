%% Elementos 


MatSecciones = zeros(size(lineas,1),1);

for i = 1 : size(lineas,1)
    
    P_ini = lineas (i,1:3);
    P_fin = lineas (i,4:6);
    
    a = find(Nodos(:,1) == P_ini(1) & ...
             Nodos(:,2) == P_ini(2) & ...
             Nodos(:,3) == P_ini(3) );
    
    b = find(Nodos(:,1) == P_fin(1) & ...
             Nodos(:,2) == P_fin(2) & ...
             Nodos(:,3) == P_fin(3) );
    
    MatElementos(i,:) = [a b];
    
    Tipo_elem = lineas (i,7);
    

    MatSecciones(i) = floor(Tipo_elem/100);% Esto cambia si hay secciones fijas
    
    
end

for i = 1 : length(MatSecciones)
    if MatSecciones(i) == 3
        MatSecciones(i) = 2;
    elseif MatSecciones(i) == 4
        MatSecciones(i) = 3;
    elseif MatSecciones(i) == 5
        MatSecciones(i) = 4;
    elseif MatSecciones(i) == 6
        MatSecciones(i) = 4;
    elseif MatSecciones(i) == 7
        MatSecciones(i) = 5;
    end
end
       


%% Completar matriz %%
%%%%%%%%%%%%%%%%%%%%%%

% MatElementos = [(1:size(MatElementos,1))' MatElementos ones(size(MatElementos,1),2)];


% ultimo = size(Nodos,1);
% for i = 5 : ultimo
%     MatElementos = [MatElementos; 1 i ; 2 i; 3 i; 4 i]; 
% end

ultimo = size(MatElementos,1);
for i = 5 : ultimo
    if MatElementos(i,1)> MatElementos(i,2)
        MatElementos(i,:) = [MatElementos(i,2) MatElementos(i,1)];
    elseif MatElementos(i,1) == MatElementos(i,2)
        Error, Elemento con distancia nula
    end
end



MatElementos = [(1:size(MatElementos,1))' MatElementos MatSecciones ones(size(MatElementos,1),1)];












    
    
    
    
