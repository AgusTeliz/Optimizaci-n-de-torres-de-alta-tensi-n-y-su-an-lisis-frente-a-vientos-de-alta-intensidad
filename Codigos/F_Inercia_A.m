function [I_A] = F_Inercia_A(A)
global a1
% I_A = a1(1)*A^4 + a1(2)*A^3 + a1(3)*A^2 + a1(4)*A + a1(5);
I_A = a1(1)*A + a1(2);
end