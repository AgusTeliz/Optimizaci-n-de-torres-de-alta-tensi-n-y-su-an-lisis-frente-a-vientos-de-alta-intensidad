%% Plot Restricciones

Porcentaje = (x-BMin)./(BMax-BMin)*100;
Var_fijas = find( isnan(Porcentaje) );
Porcentaje(Var_fijas)=[];

Porcentaje2 = (X0-BMin)./(BMax-BMin)*100;
Var_fijas2 = find( isnan(Porcentaje2) );
Porcentaje2(Var_fijas2)=[];

figure
hold on
plot([0,length(x)-length(Var_fijas)],[100 100])
plot(1:length(x)-length(Var_fijas),Porcentaje)
% plot(1:length(x)-length(Var_fijas),Porcentaje2)