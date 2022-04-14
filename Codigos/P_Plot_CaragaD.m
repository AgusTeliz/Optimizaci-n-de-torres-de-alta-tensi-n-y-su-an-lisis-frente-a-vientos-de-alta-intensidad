%% Fuerzas de masa

P_MountMM

D_m = diag(M)*3/2;

DD_F = D_m*9.8/1000; % Fuerza en kN
DD_F = DD_F(3:3:end);

DD_Act = abs(VecF(3:3:end,1));
DD_Act([77-4  78-4  111-4 112-4]) = DD_Act([77-4  78-4  111-4 112-4]) - abs(Dc);% Para sacar la fuerza de los cables
DD_Act([157-4 158-4 183-4 184-4]) = DD_Act([157-4 158-4 183-4 184-4]) - abs(Dc);
%%
% DD_F([77-4  78-4  111-4 112-4]) = DD_F([77-4  78-4  111-4 112-4]) + abs(Dc);
% DD_F([157-4 158-4 183-4 184-4]) = DD_F([157-4 158-4 183-4 184-4]) + abs(Dc);

%%
figure(1)
hold on
plot(DD_Act)
plot(DD_F)
hold off

ylabel('Fuerza (kN)')
xlabel('Nodo en el cual se aplica la carga')
% legend('Fuerza de masa - Torre op.','Fuerza F_{P}')
legend('Fuerza de gravedad - Torre inicial','Fuerza de gravedad - Torre optimizada')


% plot([0 200], [max(DD_F)  max(DD_F)])
% plot([0 200], [min(DD_F(3:3:end))  min(DD_F(3:3:end))])

min((DD_Act-DD_F)./DD_F*100)
