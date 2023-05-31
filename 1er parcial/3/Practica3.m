clc
clear all
close all
warning off all

imagen=imread("uvas1127.jpg");
tamy_imagen = size(imagen, 1)
tamx_imagen = size(imagen, 2)

disp('Elija los puntos')
figure(1)
V = impixel(imagen)

centroide = mean(V)

%clases_a=qsort(clases, @(x,y) cmpDistanciaCentro(x, y, centroide))
%clases_b=qsort(clases_a, @(x,y) cmpAnguloXY(x, y, centroide))
%clases_b=qsort(clases_b, @(x,y) cmpAnguloXY(x, y, centroide))

V_c = V - centroide;

[ax,el,r]=cart2sph(V_c(:,1),V_c(:,2),V_c(:,3));
V_s=[ax,el,r];
V_s=sortrows(V_s, [1 2 3])

[x, y, z]=sph2cart(V_s(:,1),V_s(:,2),V_s(:,3));
V_c=[x, y, z]
V = V_c + centroide

V_r = V(1:length(V) - 1, :) - V(2:length(V), :)
V_n = arrayfun(@(x, y, z) norm([x, y, z]), V_r(:, 1), V_r(:, 2), V_r(:, 3))
[sn, max_index] = sort(V_n(:),'descend')

i1 = min(max_index(1:2))
i2 = max(max_index(1:2))

clase_1 = V(1 : i1, :)
clase_2 = V(i1 + 1 : i2, :)
clase_3 = V(i2 + 1 : length(V), :)


media_c1=mean(clase_1);
media_c2=mean(clase_2);
media_c3=mean(clase_3);

continuar = 1;

while(continuar==1)
    disp('Elija un punto para identificar su clase')
    close
    figure(4)
    punto = impixel(imagen)
    
    distancias = [sqrt(sum((punto - media_c1) .^2)) sqrt(sum((punto - media_c2) .^2)) sqrt(sum((punto - media_c3) .^2))]
    
    minimo = min(distancias);
    
    disp(strcat(['La clase a la que pertenece es: ' num2str(find(distancias==minimo))]))

    plot3(clase_1(:,1),clase_1(:,2),clase_1(:,3),'ro','MarkerSize',10,'MarkerFaceColor','r')
    grid on
    hold on
    plot3(clase_2(:,1),clase_2(:,2),clase_2(:,3),'bo','MarkerSize',10,'MarkerFaceColor','b')
    plot3(clase_3(:,1),clase_3(:,2),clase_3(:,3),'yo','MarkerSize',10,'MarkerFaceColor','y')
    plot3(punto(:,1),punto(:,2),punto(:,3),'ko','MarkerSize',10,'MarkerFaceColor','k')
    legend('clase 1', 'clase 2', 'clase 3','punto')

    continuar = input(['Escriba "1" si quiere identificar la clase de otro punto: ']);
end
close


return