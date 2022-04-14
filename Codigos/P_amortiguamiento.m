%% Matriz de amortiguamiento
clc

[Q,D] = eig(K,M,'chol');

j = 0.02;

for i = 0.02
    


C_K = Q'*M^(-1/2)*i*K*M^(-1/2)*Q;
C_M = Q'*M^(-1/2)*j*M*M^(-1/2)*Q;

C_m = C_K+C_M;

zeda_1 = C_m(1,1)/(2*sqrt(D(1,1)))
zeda_2 = C_m(4,4)/(2*sqrt(D(2,2)))

end