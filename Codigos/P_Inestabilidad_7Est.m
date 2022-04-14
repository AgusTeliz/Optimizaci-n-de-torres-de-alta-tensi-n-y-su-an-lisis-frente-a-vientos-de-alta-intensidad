%%%% P_Inestabilidad_7Est

P_Mount   ;

P_MountMM ;

for Ensayo = 1:NumEstCarga
    
    P_MountMG ;
    [V,D] = eig(K,G,'chol');
    lambda = diag(D);     %%%  ??
    l = lambda(lambda>0);
    a = (1:length(lambda));
    a = a(lambda>0);
    [FC,pos] = min(l);
    Modo = a(pos);
    v = V(:,Modo);
    v = v/norm(v);
    VecU(1:NumGrLib) = v;
    FC;
    Escala = 5/max(VecU);
    
    Ensayo_print = num2str(Ensayo);
    FC_print     = num2str(FC);
    
    fprintf('|      '),fprintf('Ensayo '),fprintf(Ensayo_print),fprintf('        |   '), fprintf(FC_print),fprintf('    |  '),fprintf('\n')

end
