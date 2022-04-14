%% Apoyos

for i = 1 : 4 
    
    if Nodos(i,1) > 0 && Nodos(i,2) >= 0
        Coord = 1;
    elseif Nodos(i,1) <= 0 && Nodos(i,2) > 0
        Coord = 2;
    elseif Nodos(i,1) < 0 && Nodos(i,2) <= 0
        Coord = 3;
    elseif Nodos(i,1) >= 0 && Nodos(i,2) < 0
        Coord = 4;
    else
        Error
    end
    
    x = find(MatVarPos(1:2,2) == abs(Nodos(i,1)));
    y = find(MatVarPos(1:2,2) == abs(Nodos(i,2)));
    z = MatVarPosFix(1,1)   ;

MatNodos(i,:) = [x y z Coord];
    
end


%% Barras iniciales

for i = 5 : 20 

    if Nodos(i,1)      > 0 && Nodos(i,2) >= 0
        Coord = 1;
    elseif Nodos(i,1) <= 0 && Nodos(i,2) >  0
        Coord = 2;
    elseif Nodos(i,1) < 0 && Nodos(i,2)  <= 0
        Coord = 3;
    elseif Nodos(i,1) >= 0 && Nodos(i,2) <  0
        Coord = 4;
    else
        Error
    end
    
    z = find(MatVarPos(:,2) == Nodos(i,3));

    
    if Nodos(i,1)==0
        x = MatVarPosFix(1,1)   ;
    else
        x = find(MatVarPos(1:z,2) == abs(Nodos(i,1)));
    end
    
    if Nodos(i,2)==0
        y = MatVarPosFix(1,1)   ;
    else
        y = find(MatVarPos(1:z,2) == abs(Nodos(i,2)));
    end
    

MatNodos(i,:) = [x y z Coord];
    
end

%% Resto de las barras


for i = 21 : size(Nodos,1)
    
    if i==77
        aaaaaa=1;
    end
    
    
    if     Nodos(i,1) >  0 && Nodos(i,2) >= 0
        Coord = 1;
    elseif Nodos(i,1) <= 0 && Nodos(i,2) > 0
        Coord = 2;
    elseif Nodos(i,1) <  0 && Nodos(i,2) <= 0
        Coord = 3;
    elseif Nodos(i,1) >= 0 && Nodos(i,2) < 0
        Coord = 4;
    else
        Error
    end
    
    
    z = find(MatVarPos(:,2) == Nodos(i,3));
    
    a = length( find( Dist(:,3) == Nodos(i,3) ) )+1;

    
    if Nodos(i,1)==0
        x = MatVarPosFix(1,1)   ;
    else
        x = find(MatVarPos(z-a:z,2) == abs(Nodos(i,1))) + z-a-1;
    end
    
    if Nodos(i,2)==0
        y = MatVarPosFix(1,1)   ;
    else
        y = find(MatVarPos(z-a:z,2) == abs(Nodos(i,2))) + z-a-1;
    end
    

MatNodos(i,:) = [x y z Coord];
    
end

MatNodos = [(1:size(MatNodos,1))' MatNodos];

















