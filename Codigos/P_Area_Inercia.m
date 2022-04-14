global a1
Area_inercia = load('Area_Inercia_2.txt');

Area = Area_inercia(1:end-1,1);
Inercia = Area_inercia(1:end-1,2);
Rad_giro = Area_inercia(1:end-1,3); % Radio de gira
 
a1 = polyfit(Area,Inercia./Area,1);
t  = (0:0.1:Area(end))';

a1 = a1*0.75;

I_A = @(A) a1(1)*A + a1(2);

Ploteo_Area_Inercia = 0;

if Ploteo_Area_Inercia==1
    figure
    plot(Area,Inercia./Area,'*',t,I_A(t))
    xlabel('Área (mm^2)')
    ylabel('Inercia/Área (mm^2)')
    legend('Datos de tablas','Función utilizada','Location','southeast')
end




