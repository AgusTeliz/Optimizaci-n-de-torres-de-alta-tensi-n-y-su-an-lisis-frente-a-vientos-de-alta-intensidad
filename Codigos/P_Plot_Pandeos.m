%% P_Plot_Pandeos

Usar_Fac_ad = 0;
Eele = 200;
Fy = 0.250;

if Usar_Fac_ad == 1
    Factor_ad = 1.5;
    Factor_ad_plot = 1.225622;
elseif Usar_Fac_ad == 0
    Factor_ad = 1;
    Factor_ad_plot = 1;
end

Lambda_Euler = (72.5*Factor_ad_plot:200)';
Pand_op = pi^2*Eele./(Lambda_Euler.^2)/1.67;



Lambda_gr = (1:200)';
Fe = pi^2*Eele./Lambda_gr.^2;

Fcr1 = zeros(size(Lambda_gr));
for i = 1:length(Lambda_gr)
    Fcr1(i) = (0.658^(Fy/Fe(i)))*Fy/1.67;
end

Fcr2 = 0.877*Fe/1.67;

Lambad_Cr = round(4.71*sqrt(Eele/Fy));
pos_Lambad_Cr = find(Lambda_gr == Lambad_Cr);

Lambda_graf_1 = Lambda_gr(Lambda_gr<=120);
Lambda_graf_2 = Lambda_gr(Lambda_gr>120);

Lambda_graf_1 = 60+0.8*Lambda_graf_1;
Lambda_graf_2 = 45+Lambda_graf_2    ;

figure
axis([10 200 0 0.2*1e3])
hold on
plot(Lambda_Euler,Pand_op/1.5*1e3,'b')
plot(Lambda_gr(1:Lambad_Cr),Fcr1(1:Lambad_Cr)*1e3,'r')
plot([10 72.5*Factor_ad_plot],[0.25/1.67/Factor_ad 0.25/1.67/Factor_ad]*1e3,'b')
plot(Lambda_gr(Lambad_Cr:end),Fcr2(Lambad_Cr:end)*1e3,'r')
grid minor
xlabel('Esbeltez \lambda')
ylabel('Tensión máxima a compresión (MPa)')
legend('Criterio de la optimiazción','Criterios de la Norma AISC')


%% Plotear esbelteces de las barras (Largo/3)
%% Capaz que con un histograma
% 
% Vec_Lambda = zeros(NumElementos,1);
%     for Elem = 1 : NumElementos
% 
%         %************************************************************************************
%         % Matriz elemento -------------------------------------------------------------------
% 
%         Nod1 = MatElementos(Elem,N1); % Se supone que Nod1 < Nod2 (Ver: Cambio orden en Lectura)
%         Nod2 = MatElementos(Elem,N2);
% 
%         Sis1 = MatNodos(Nod1,Si);
%         Sis2 = MatNodos(Nod2,Si);
% 
%         Co1X = MatSisCoord(Sis1,XX);
%         Co1Y = MatSisCoord(Sis1,YY);
%         Co1Z = MatSisCoord(Sis1,ZZ);
%         Co2X = MatSisCoord(Sis2,XX);
%         Co2Y = MatSisCoord(Sis2,YY);
%         Co2Z = MatSisCoord(Sis2,ZZ);
% 
%         Var1X = MatNodos(Nod1,VX);
%         Var1Y = MatNodos(Nod1,VY);
%         Var1Z = MatNodos(Nod1,VZ);
%         Var2X = MatNodos(Nod2,VX);
%         Var2Y = MatNodos(Nod2,VY);
%         Var2Z = MatNodos(Nod2,VZ);
% 
%         X1 = Co1X*MatVarPosR(Var1X,Co);
%         Y1 = Co1Y*MatVarPosR(Var1Y,Co);
%         Z1 = Co1Z*MatVarPosR(Var1Z,Co);
%         X2 = Co2X*MatVarPosR(Var2X,Co);
%         Y2 = Co2Y*MatVarPosR(Var2Y,Co);
%         Z2 = Co2Z*MatVarPosR(Var2Z,Co);
% 
%         DX = (X2 - X1)/3;
%         DY = (Y2 - Y1)/3;
%         DZ = (Z2 - Z1)/3;
% 
%         LL = sqrt(DX*DX + DY*DY + DZ*DZ);
%         LI = CD1/LL;
% 
%         XL = LI*DX;
%         YL = LI*DY;
%         ZL = LI*DZ;
% 
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%  Propiedades geomÃ©tricas del elemento y propiedades del material  %%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
%         VarS = MatElementos(Elem,VS);
%         Mate = MatElementos(Elem,Ma);
% 
%         Aele = MatVarSecR(VarS,Ax);
%         Eele = MatMaterialesR(Mate,EE);
%         
% 
%         ra = Rad_giro(Num_A_elem)/1000;
%             
%         if LL/ra <= 75              %% Calcula la esbeltez
%             lambda =  60+0.8*LL/ra;
%         elseif LL/ra > 75  
%             lambda =  45+LL/ra;
%         else
%             fprint('Error en esbeltez')
%         end
%         
%         Vec_Lambda(Elem) = lambda;
% 
%     end
    
% figure
% hist(Vec_Lambda)
% hold on
% plot(Lambda_graf,Pand_op*1000)
% plot(Lambda_graf(1:Lambad_Cr),Fcr1(1:Lambad_Cr)*1000)
% plot(Lambda_graf(Lambad_Cr:end),Fcr2(Lambad_Cr:end)*1000)
% plot([10 200],[0.20/1.67*1000 0.20/1.67*1000])
