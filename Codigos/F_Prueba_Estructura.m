X0 = [MatVarSecR(1:NumVarSec,1); MatVarPosR(1:NumVarPos,1)];

BMin = [MatVarSecR(1:NumVarSec,2); MatVarPosR(1:NumVarPos,2)];
BMax = [MatVarSecR(1:NumVarSec,3); MatVarPosR(1:NumVarPos,3)];


options = optimoptions('fmincon','Algorithm','sqp','FiniteDifferenceStepSize',1e-6,...
    'OptimalityTolerance',1e-15,'ConstraintTolerance',1e-4,'MaxIterations',800,...
    'Display','iter-detailed','MaxFunctionEvaluations',100000,...
    'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,'CheckGradients',false,'StepTolerance',1e-15);
tic
x = fmincon(@(X) F_Costo(X),X0,[],[],[],[],BMin,BMax,@(X) F_Restricciones(X),options);
toc;

MatVarSecR(1:NumVarSec,1) = x(1:NumVarSec,1);
MatVarPosR(1:NumVarPos,1) = x(NumVarSec+1:end,1);
X0 = [MatVarSecR(1:NumVarSec,1); MatVarPosR(1:NumVarPos,1)];
% options = optimoptions('fmincon','algorithm','interior-point','TolX',1e-6,'Display','iter-detailed','TolFun',1e-6, ...
%        'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,'CheckGradients',false);


% Plot
K = F_MountMK(x);
VecU = F_MountVecU(K);
Sigma = F_MountSigma(x,VecU);

% P_Plot;


% P_Plot_U;
