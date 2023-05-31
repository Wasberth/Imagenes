clc
clear all
close all   
warning off all

imagen=imread("https://img.freepik.com/foto-gratis/playa-tropical_74190-188.jpg?w=2000");
tamy_imagen = size(imagen, 1)
tamx_imagen = size(imagen, 2)

disp('Elija los puntos de la primera clase')
figure(1)
clase1 = impixel(imagen)

disp('Elija los puntos de la segunda clase')
close
figure(2)
clase2 = impixel(imagen)

disp('Elija los puntos de la tercera clase')
close
figure(3)
clase3 = impixel(imagen)


media_c1=mean(clase1)
media_c2=mean(clase2)
media_c3=mean(clase3)
%media_c1=media_c1'

continuar = 1

while(continuar==1)
    disp('Elija un punto para identificar su clase')
    close
    close
    figure(4)
    punto = impixel(imagen)
    
    distancias = [sqrt(sum((punto - media_c1) .^2)) sqrt(sum((punto - media_c2) .^2)) sqrt(sum((punto - media_c3) .^2))]
    
    minimo = min(distancias);
    
    disp(strcat(['La clase a la que pertenece es: ' num2str(find(distancias==minimo))]))

    plot3(clase1(:,1),clase1(:,2),clase1(:,3),'ro','MarkerSize',10,'MarkerFaceColor','r')
    grid on
    hold on
    plot3(clase2(:,1),clase2(:,2),clase2(:,3),'bo','MarkerSize',10,'MarkerFaceColor','b')
    plot3(clase3(:,1),clase3(:,2),clase3(:,3),'yo','MarkerSize',10,'MarkerFaceColor','y')
    %plot3(c2(1,:),c2(2,:),c2(3,:),'bo','MarkerSize',10,'MarkerFaceColor','b')
    %plot3(c3(1,:),c3(2,:),c3(3,:),'yo','MarkerSize',10,'MarkerFaceColor','y')
    plot3(punto(:,1),punto(:,2),punto(:,3),'ko','MarkerSize',10,'MarkerFaceColor','k')
    legend('clase 1', 'clase 2', 'clase 3','punto')

    continuar = input(['Escriba "1" si quiere identificar la clase de otro punto: ']);
end
close


return