x0=X0;

[ f0, g0, df0, dg0 ] = F_Restricciones(x0);

%return
df1n = zeros(size(df0));
df2n = zeros(size(df0));

DELTA1 = 1e-4;
DELTA2 = 1e-10;

for var = 1:length(x0)
    x1 = x0;
    x1(var) = x1(var) + DELTA1;
    [ f1, ~, ~, ~ ] = F_Restricciones(x1);
    df1n(var,:) = (f1-f0)/DELTA1;
    x2 = x0;
    x2(var) = x2(var) + DELTA2;
    K = F_MountMK(x2);
    [ f2, ~, ~, ~ ] = F_Restricciones(x2);
    df2n(var,:) = (f2-f0)/DELTA2;
end
