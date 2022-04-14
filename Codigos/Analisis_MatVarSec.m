
Secciones = lineas(:,7);

i = 1;
while i < size(Secciones,1)
    a = find(Secciones(i+1:end,1) == Secciones(i,1));
    
    Secciones(a+i,:) = [];
    
    i = i+1;

end



MatVarSec = zeros(5,6); % Esto cambia si hay alguna seccion fija


%     Ai = [Area(29) Area(16) Area(16) Area(22) Area(16) Area(16) Area(16)]; % Tiene que estar definida desde Autocad en la columna 8
    Ai = [Area(29) Area(16) Area(22) Area(16) Area(22)]; % Tiene que estar definida desde Autocad en la columna 8
    
    Aminima1 = Area(8);
    Aminima2 = Area(3);
    
    
    Amaxima = Area(end);
    

for i = 1 : 5
               % Poner un if por si el area es fija o variable
    if Ai(i) == Area(29) || Ai(i) == Area(22)
        MatVarSec(i,:) = [i Ai(i) 1 1 Aminima1 Amaxima];
    else
        MatVarSec(i,:) = [i Ai(i) 1 1 Aminima2 Amaxima];
    end
end


MatVarSecFix = [size(MatVarSec,1)+1 1e3];












