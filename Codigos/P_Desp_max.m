%% Desplazamiento maximo
Uplot_z0 =  Uplot(:,1:2,:);

Desp_vec = sqrt(Uplot_z0(:,1,:).^2 + Uplot_z0(:,2,:).^2);

[Desp_max,Ens] = max(max(abs(Desp_vec)));