%% Analisis dinamico

% No anda

P_PerfilesNormalizados;
NumEstCarga = 1;
K = F_MountMK(X0);

Fac_diseno = 1.67;

% F_norm = load('Fuerzas_normales_1.txt');
F_norm = load('Fuerzas_normales_Newmark.txt');



Desp_Din = load('Desplazamientos_Din.txt');
Desp_Din(2:2:end,:)=[];    % Elimino giros (valores nulos)
Desp_Din(1:12,:)   =[];    % Elimino los apoyos

tiempos = size(F_norm,2);


% Sigma_1 = F_MountSigma(X0,Desp_Din(:,tiempo))*1e3;

Sigma_t = F_norm./(MatVarSecR(MatElementos(:,3))); % area en cm2


SigPand = F_SigmaPandeo(X0);


% SigmaMax_1 = [];
% SigmaPandeo = [];
for i = 1 : tiempos
    SigmaMax_1(:,i) = SigmaMax(1:NumElementos)*1e3;
    SigmaPandeo(:,i) = SigPand*1e3;
end

    FS_2 =  [SigmaMax_1./abs(Sigma_t)*Fac_diseno; SigmaPandeo./Sigma_t*Fac_diseno];
    FS_2(FS_2<0) = 5.5;
    FS_2(FS_2==inf) = 5.5;



for i = 1 : tiempos
    FS_min(i) = min(FS_2(:,i)); 
    
end



figure(1)
hold on
plot(FS_min)
ylabel('Factor de seguridad')
xlabel('Tiempo (s)')
axis([100 600 0 5])
grid minor

hold on
plot([0 700],[1.67 1.67])
plot([0 700],[1 1])
legend('Factor de seguridad de la estructura','Límite a la falla','Límite de fluencia o pandeo local')

% plot(FS_min)
% ylabel('Factor de seguridad')
% xlabel('Tiempo (s)')
% axis([100 700 0 2.5])
% grid minor






