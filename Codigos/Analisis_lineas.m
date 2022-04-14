
lineas = load('Lineas1.txt');
lineas(:,1:6) = lineas(:,1:6)/10e6; % para pasar a milimetros, sale mal del autocad


%% Graficar la torre extraida de excel
Figura = 0;

if Figura == 1
    figure(1)
    hold on
    for i=1:size(lineas,1)
        plot3([lineas(i,1) lineas(i,4)],[lineas(i,2) lineas(i,5)],[lineas(i,3) lineas(i,6)],'b')
    end
    axis equal
end




%% Nodos

Nodos = [lineas(:,4:6);lineas(:,1:3)] ;
[~,Orden] = sort(Nodos(:,3)); 
Nodos = Nodos(Orden,:);


i = 1;
while i < size(Nodos,1)
    a = find(Nodos(i+1:end,1) == Nodos(i,1) & ...
             Nodos(i+1:end,2) == Nodos(i,2) & ...
             Nodos(i+1:end,3) == Nodos(i,3));
    
    Nodos(a+i,:) = [];
    
    i = i+1;

end



%% Matriz de Variables de Posicion
 % dist_x dist_y dist_z

Dist = abs(Nodos);
 
i = 1;
while i < size(Dist,1)
    a = find(Dist(i+1:end,1) == Dist(i,1) & ...
             Dist(i+1:end,2) == Dist(i,2) & ...
             Dist(i+1:end,3) == Dist(i,3) );
    
    b = find(Dist(i+1:end,1) == Dist(i,2) & ...
             Dist(i+1:end,2) == Dist(i,1) & ...
             Dist(i+1:end,3) == Dist(i,3) );
    
         
    Dist([a+i;b+i],:) = [];
    
    i = i+1;
end

%% ordenados por altura en Z
[~,Orden] = sort(Dist(:,3)); 
Dist = Dist(Orden,:);


i = 1;
MatVarPos = [];
while i <= size(Dist,1)
    
    a = find(Dist(i:end,3) == Dist(i,3));
    
    A = Dist(a+i-1,:);
    A = A(:);
    
    q = 1;
    
    while q < size(A,1)
    b = find(A(q+1:end) == A(q));
             
    A(b+q) = [];
    
    q = q+1;
    end
    
    MatVarPos = [MatVarPos ; A ];
    
    i = i+length(a);
end

MatVarPos(MatVarPos==0)=[];

%% Completando la matriz

MatVarPos = [(1:length(MatVarPos))' MatVarPos ones(length(MatVarPos),2) MatVarPos MatVarPos];

MatVarPos(1:2:end-1,5) = MatVarPos(1:2:end-1,5)*0.2;
MatVarPos(1:2:end-1,6) = MatVarPos(1:2:end-1,6)*5;

MatVarPos(2:2:end,5) = MatVarPos(2:2:end,5)*0.9;
MatVarPos(2:2:end,6) = MatVarPos(2:2:end,6)*1.1;

MatVarPos(end,5) = MatVarPos(end,5)*0.5;
MatVarPos(end,6) = MatVarPos(end,6)*1.5;



    


















        
        
        