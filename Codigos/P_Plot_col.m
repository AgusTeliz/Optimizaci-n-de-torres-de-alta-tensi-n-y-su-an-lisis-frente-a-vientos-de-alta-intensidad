Graficar__ = 1;

if Graficar__== 1
    a = size(MatNodos,2)-3;
    
    figure(1)
    hold on
    for i = 1 : size(MatResCol,1)
        
        Coox = MatSisCoord(MatNodos(MatResCol(i,1),a+3),1);
        Cooy = MatSisCoord(MatNodos(MatResCol(i,1),a+3),2);
        Cooz = MatSisCoord(MatNodos(MatResCol(i,1),a+3),3);
        
        plot3( [MatVarPosR(MatNodos(MatResCol(i,1),a)  ,1)*Coox MatVarPosR(MatNodos(MatResCol(i,2),a  ),1)*Coox] ,...
               [MatVarPosR(MatNodos(MatResCol(i,1),a+1),1)*Cooy MatVarPosR(MatNodos(MatResCol(i,2),a+1),1)*Cooy] ,...
               [MatVarPosR(MatNodos(MatResCol(i,1),a+2),1)*Cooz MatVarPosR(MatNodos(MatResCol(i,2),a+2),1)*Cooz] ,...
                '-b*','linewidth',1)
           
        plot3( [MatVarPosR(MatNodos(MatResCol(i,1),a)  ,1)*Coox MatVarPosR(MatNodos(MatResCol(i,3),a  ),1)*Coox] ,...
               [MatVarPosR(MatNodos(MatResCol(i,1),a+1),1)*Cooy MatVarPosR(MatNodos(MatResCol(i,3),a+1),1)*Cooy] ,...
               [MatVarPosR(MatNodos(MatResCol(i,1),a+2),1)*Cooz MatVarPosR(MatNodos(MatResCol(i,3),a+2),1)*Cooz] ,'-*b')
        
        plot3( [MatVarPosR(MatNodos(MatResCol(i,2),a)  ,1)*Coox MatVarPosR(MatNodos(MatResCol(i,3),a  ),1)*Coox] ,...
               [MatVarPosR(MatNodos(MatResCol(i,2),a+1),1)*Cooy MatVarPosR(MatNodos(MatResCol(i,3),a+1),1)*Cooy] ,...
               [MatVarPosR(MatNodos(MatResCol(i,2),a+2),1)*Cooz MatVarPosR(MatNodos(MatResCol(i,3),a+2),1)*Cooz] ,...
               '-ro','linewidth',1)
        
    end
%     plot3( [MatVarPosR(MatNodos(Nodo_ini_glob,a),1)   MatVarPosR(MatNodos(Nodo_fin_glob,a)  ,1)] ,...
%            [MatVarPosR(MatNodos(Nodo_ini_glob,a+1),1) MatVarPosR(MatNodos(Nodo_fin_glob,a+1),1)] ,...
%            [MatVarPosR(MatNodos(Nodo_ini_glob,a+2),1) MatVarPosR(MatNodos(Nodo_fin_glob,a+2),1)],'b')
end


% 
% for i = 1 : size(Laterales,1)-1
%     
%     plot3( [Laterales(i,1) Laterales(i+1,1)] , ...
%            [Laterales(i,2) Laterales(i+1,2)] , ...
%            [Laterales(i,3) Laterales(i+1,3)] ,'k*')
%     
% end

