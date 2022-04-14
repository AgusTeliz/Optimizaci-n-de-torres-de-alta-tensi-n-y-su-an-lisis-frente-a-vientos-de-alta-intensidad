%% Analisis dinamico
P_Viento
%% Condiciones iniciales

% P_MatrizC
C = eye(NumGrLib) * 0.5;


P_MountMM;
% P_MountMK

% M = M;  %  ton
% K = K;  % kN/m


u_0 = zeros(NumGrLib,1);
v_0 = zeros(NumGrLib,1);
F_1 = zeros(NumGrLib,1);
F_g = zeros(NumGrLib,1);

F_g(3:3:end) = VecF(3:3:end,1);
F_1(1:3:end) = VecF(1:3:end,2)/43.9; % proporcion de fuerza que se le aplica a cada nodo

% M_D = diag(M);
% F_g(3:3:end) = -M_D(3:3:end)*9.8/1000; %Fuerza de gravedad en kN

F_0 = F_1*F_t(1);

a_0 = M^-1*(F_0+F_g); % m/s^2


delta = 1/2 ;
alpha = 1/4 ;

c0 = 1/(alpha*dt^2); c1 = delta/(alpha*dt);       c2 = 1/(alpha*dt); c3 = 1/(2*alpha)-1;

c4 = delta/alpha-1;    c5 = dt/2*(delta/alpha-2); c6 = dt*(1-delta); c7 = delta*dt;

K_t = K + c0*M + c1*C;

u  = zeros(NumGrLib,2); % vectores que contienen
ve = zeros(NumGrLib,2); % datos en tiempo t y t+dt
ac = zeros(NumGrLib,2);

u(:,1)  = u_0 ;
ve(:,1) = v_0 ;
ac(:,1) = a_0 ;

X0 = [MatVarSecR(1:NumVarSec,1); MatVarPosR(1:NumVarPos,1)];
SigPand = F_SigmaPandeo(X0);
FS = zeros(length(t_sim),1);
FS(1) = inf;
NumEstCarga = 1;
SigmaMax = SigmaMax(1:NumElementos);



for i = 1:length(t_sim)-1
    
    F_f = (F_g+F_1*F_t(i+1)) + M*(c0*u(:,1) + c2*ve(:,1) + c3*ac(:,1) )...
           + C*(c1*u(:,1) + c4*ve(:,1) + c5*ac(:,1));
    u(:,2)  = K_t^-1*F_f;
    ac(:,2) = c0*(u(:,2)-u(:,1)) - c2*ve(:,1) - c3*ac(:,1);
    ve(:,2) = ve(:,1) + c6*ac(:,1) + c7*ac(:,2);
    
%   P_FactSeg
   
    Sigma = F_MountSigma(X0,u(:,2));
    
    
    Esf_traccion = Sigma;
    Esf_traccion(Esf_traccion <= 0) = 1e-6;
    
    Esf_comp = Sigma;
    Esf_comp(Esf_comp >= 0)  = -1e-6 ;
    
%     FS_1 = min(SigmaMax(1:NumElementos)./Esf_traccion);
%     FS_2 = min(SigPand./Esf_comp);
%     FS(i) = min([FS_1 FS_2]);
    
    FS(i+1) = min([SigmaMax(1:NumElementos)./Esf_traccion ; SigPand./Esf_comp ; -SigmaMax(1:NumElementos)./Esf_comp]);
%     F_t(i)
%     FS(i)
    u(:,1) = u(:,2);
    ve(:,1) = ve(:,2);
    ac(:,1) = ac(:,2);
    
    
    
end

figure
plot(t_sim,FS)
hold on
ylabel('Factor de seguridad')
xlabel ('Tiempo [s]')

min(FS)
% axis([100 600 0 5])
    
    
    