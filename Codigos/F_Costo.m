function [ f, df ] = F_Costo(X)

f = F_MountCost(X);

if (nargout>1)
    df = F_MountDCost(X);

    df = df';
end

end
