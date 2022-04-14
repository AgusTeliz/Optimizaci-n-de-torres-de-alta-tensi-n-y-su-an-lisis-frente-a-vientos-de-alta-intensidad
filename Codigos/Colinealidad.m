%%
B = find(lineas(:,7)==101);
Laterales = lineas(B,1:6);
Nodos_lat = [Laterales(:,4:6);Laterales(:,1:3)] ; % Nodos repetidos (inicios y finales de las lineas)
[~,Orden] = sort(Nodos_lat(:,3)); 
Nodos_lat = Nodos_lat(Orden,:); % Ordeno por altura

i = 1;
while i < size(Nodos_lat,1) %Elimino los nodos repetidos
    a = find(Nodos_lat(i+1:end,1) == Nodos_lat(i,1) & ...
             Nodos_lat(i+1:end,2) == Nodos_lat(i,2) & ...
             Nodos_lat(i+1:end,3) == Nodos_lat(i,3));
    
    Nodos_lat(a+i,:) = [];
    
    i = i+1;

end

d = sqrt(sum((Nodos_lat(1,:)-Nodos_lat(end,:)).^2));
Nodo_ini = 1;
Nodo_fin = size(Nodos_lat,1);

for i = 1 : size(Nodos_lat,1) % Busco los nodos extremos
    for j = i+1 : size(Nodos_lat,1)
        if sqrt(sum((Nodos_lat(i,:)-Nodos_lat(j,:)).^2)) > d
            d = sqrt(sum((Nodos_lat(i,:)-Nodos_lat(j,:)).^2));
            Nodo_ini = i;
            Nodo_fin = j;
        end
    end
end


Nodos_lat_glob = zeros(size(Nodos_lat,1),1);  % Busco los nodos referidos a la MatNodos
for i = 1 : size(Nodos_lat,1)
    Nodos_lat_glob(i) = find( MatVarPosTot(MatNodos(1:end,2),2) == Nodos_lat(i,1) & ...
                              MatVarPosTot(MatNodos(1:end,3),2) == Nodos_lat(i,2) & ...
                              MatVarPosTot(MatNodos(1:end,4),2) == Nodos_lat(i,3) & ...
                              MatNodos(1:end,5) == 1);
end

Nodo_ini_glob = Nodos_lat_glob(Nodo_ini);
Nodo_fin_glob = Nodos_lat_glob(Nodo_fin);
Nodos_lat_glob([Nodo_ini;Nodo_fin]) = [];

MatResCol_lat_1 = zeros(size(Nodos_lat_glob,1),3);
for i = 1: size(Nodos_lat_glob,1)
    MatResCol_lat_1(i,:) = [Nodos_lat_glob(i) Nodo_ini_glob  Nodo_fin_glob];
end


%%
B = find(lineas(:,7)==401);
Laterales = lineas(B,1:6);
Nodos_lat = [Laterales(:,4:6);Laterales(:,1:3)] ; % Nodos repetidos (inicios y finales de las lineas)
[~,Orden] = sort(Nodos_lat(:,3)); 
Nodos_lat = Nodos_lat(Orden,:); % Ordeno por altura

i = 1;
while i < size(Nodos_lat,1) %Elimino los nodos repetidos
    a = find(Nodos_lat(i+1:end,1) == Nodos_lat(i,1) & ...
             Nodos_lat(i+1:end,2) == Nodos_lat(i,2) & ...
             Nodos_lat(i+1:end,3) == Nodos_lat(i,3));
    
    Nodos_lat(a+i,:) = [];
    
    i = i+1;

end

d = sqrt(sum((Nodos_lat(1,:)-Nodos_lat(end,:)).^2));
Nodo_ini = 1;
Nodo_fin = size(Nodos_lat,1);

for i = 1 : size(Nodos_lat,1) % Busco los nodos extremos
    for j = i+1 : size(Nodos_lat,1)
        if sqrt(sum((Nodos_lat(i,:)-Nodos_lat(j,:)).^2)) > d
            d = sqrt(sum((Nodos_lat(i,:)-Nodos_lat(j,:)).^2));
            Nodo_ini = i;
            Nodo_fin = j;
        end
    end
end


Nodos_lat_glob = zeros(size(Nodos_lat,1),1);  % Busco los nodos referidos a la MatNodos
for i = 1 : size(Nodos_lat,1)
    Nodos_lat_glob(i) = find( MatVarPosTot(MatNodos(1:end,2),2) == Nodos_lat(i,1) & ...
                              MatVarPosTot(MatNodos(1:end,3),2) == Nodos_lat(i,2) & ...
                              MatVarPosTot(MatNodos(1:end,4),2) == Nodos_lat(i,3) & ...
                              MatNodos(1:end,5) == 1);
end

%% Restriccion con las puntas
Nodo_ini_glob = Nodos_lat_glob(Nodo_ini);
Nodo_fin_glob = Nodos_lat_glob(Nodo_fin);
Nodos_lat_glob([Nodo_ini;Nodo_fin]) = [];

MatResCol_lat_2 = zeros(size(Nodos_lat_glob,1),3);
for i = 1: size(Nodos_lat_glob,1)
    MatResCol_lat_2(i,:) = [Nodos_lat_glob(i) Nodo_ini_glob  Nodo_fin_glob];
end





MatResCol = [(1:(size(MatResCol_lat_1,1)+size(MatResCol_lat_2,1)))' [MatResCol_lat_1;MatResCol_lat_2]];




