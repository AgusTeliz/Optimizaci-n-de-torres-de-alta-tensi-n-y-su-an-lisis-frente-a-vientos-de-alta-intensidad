%% P_Plot_Pandeos_2

E = 200 ; % GPa
Fy = 250e-3; % MPa


Lambda = (1:0.1:200)';
Lambda_ra = Lambda/1.5;

Lambda_crit_1 = 60+0.8*Lambda_ra;
Lambda_crit_2 = 45+Lambda_ra    ;

lambda_critico = max(Lambda_crit_1,Lambda_crit_2);

Pand_op = pi^2*E./(Lambda.^2)/1.67; % Programa


Fe = pi^2*E./lambda_critico.^2;

F_crit_1 = zeros(length(Lambda_crit_1));
for i = 1:length(Lambda_crit_1)
    F_crit_1(i) = (0.658^(Fy/Fe(i)))*Fy/1.67;
end

F_crit_2 = 0.877*Fe/1.67;



Lambad_Cr = round((4.71*sqrt(E/Fy)-45)*1.5);
pos_Lambad_Cr = find(Lambda == Lambad_Cr);


Pand_op  = Pand_op  * 1000 ; % Para pasar a MPa
F_crit_1 = F_crit_1 * 1000 ;
F_crit_2 = F_crit_2 * 1000 ;

figure
hold on
semilogy(Lambda,Pand_op)
semilogy(Lambda(1:pos_Lambad_Cr),F_crit_1(1:pos_Lambad_Cr))
semilogy(Lambda(pos_Lambad_Cr:end),F_crit_2(pos_Lambad_Cr:end))
semilogy([1 200],[250/1.67 250/1.67])
axis([1 200 0 300])
xlabel('Esbeltez \lambda')
ylabel('Esfuerzo critico de pandeo (MPa)')

figure
hold on
semilogy(Lambda,Pand_op/1.5)
semilogy(Lambda(1:pos_Lambad_Cr),F_crit_1(1:pos_Lambad_Cr))
semilogy(Lambda(pos_Lambad_Cr:end),F_crit_2(pos_Lambad_Cr:end))
semilogy([1 200],[250/1.67/1.5 250/1.67/1.5])
axis([1 200 0 200])
xlabel('Esbeltez \lambda')
ylabel('Esfuerzo critico de pandeo (MPa)')




