clc
clear all
close all
warning off all

imagen=imread("../Practica_3/uvas1127.jpg");
tamy_imagen = size(imagen, 1);
tamx_imagen = size(imagen, 2);

cantidad = input('Ingrese la cantidad de representantes por clase: ');

disp('Haga clic en donde está la primera clase')
figure(1)
imshow(imagen)
[tmpx,tmpy] = ginput(1);
close

limx1=int64(tmpx-50);
limy1=int64(tmpy-50);

if(limx1<0)
    limx1=0;
end
if(limx1>(tamx_imagen-100))
    limx1 = tamx_imagen-100;
end
if(limy1>(tamy_imagen-100))
    limy1 = tamy_imagen-100;
end
if(limy1<0)
    limy1=0;
end

c1x = randi([limx1, limx1+100],1,cantidad);
c1y = randi([limy1, limy1+100],1,cantidad);

clase_1 = impixel(imagen,c1x(1,:),c1y(1,:));

nombre1 = input('Ingrese el nombre de la clase: ', 's');


disp('Haga clic en donde está la segunda clase')
figure(2)
imshow(imagen)
[tmpx,tmpy] = ginput(1);
close

limx2=int64(tmpx-50);
limy2=int64(tmpy-50);

if(limx2<0)
    limx2=0;
end
if(limy2<0)
    limy2=0;
end
if(limx2>(tamx_imagen-100))
    limx2 = tamx_imagen-100;
end
if(limy2>(tamy_imagen-100))
    limy2 = tamy_imagen-100;
end

c2x = randi([limx2, limx2+100],1,cantidad);
c2y = randi([limy2, limy2+100],1,cantidad);

clase_2 = impixel(imagen,c2x(1,:),c2y(1,:));

nombre2 = input('Ingrese el nombre de la clase: ', 's');


disp('Haga clic en donde está la tercera clase')
figure(3)
imshow(imagen)
[tmpx,tmpy] = ginput(1);
close

limx3=int64(tmpx-50);
limy3=int64(tmpy-50);

if(limx3<0)
    limx3=0;
end
if(limy3<0)
    limy3=0;
end
if(limx3>(tamx_imagen-100))
    limx3 = tamx_imagen-100;
end
if(limy3>(tamy_imagen-100))
    limy3 = tamy_imagen-100;
end

c3x = randi([limx3, limx3+100],1,cantidad);
c3y = randi([limy3, limy3+100],1,cantidad);

clase_3 = impixel(imagen,c3x(1,:),c3y(1,:));

nombre3 = input('Ingrese el nombre de la clase: ', 's');


media_c1=mean(clase_1);
media_c2=mean(clase_2);
media_c3=mean(clase_3);

if(isnan(clase_1))
    media_c1=clase_1(1,1);
end
if(isnan(clase_2))
    media_c1=clase_2(1,1);
end
if(isnan(clase_3))
    media_c1=clase_3(1,1);
end



std_1 = std(clase_1);
std_2 = std(clase_2);
std_3 = std(clase_3);

range_1 = [media_c1 - std_1, std_1 + media_c1];
range_2 = [media_c2 - std_2, std_2 + media_c2];
range_3 = [media_c3 - std_3, std_3 + media_c3];


r = clase_1(:,1);
index = find((r>=range_1(1) & r<=range_1(4)));
clase_1 = clase_1(index, :);

g = clase_1(:,2);
index = find((g>=range_1(2) & g<=range_1(5)));
clase_1 = clase_1(index, :);

b = clase_1(:,3);
index = find((b>=range_1(3) & b<=range_1(6)));
clase_1 = clase_1(index, :);





r = clase_2(:,1);
index = find((r>=range_2(1) & r<=range_2(4)));
clase_2 = clase_2(index, :);

g = clase_2(:,2);
index = find((g>=range_2(2) & g<=range_2(5)));
clase_2 = clase_2(index, :);

b = clase_2(:,3);
index = find((b>=range_2(3) & b<=range_2(6)));
clase_2 = clase_2(index, :);



r = clase_3(:,1);
index = find((r>=range_3(1) & r<=range_3(4)));
clase_3 = clase_3(index, :);

g = clase_3(:,2);
index = find((g>=range_3(2) & g<=range_3(5)));
clase_3 = clase_3(index, :);

b = clase_3(:,3);
index = find((b>=range_3(3) & b<=range_3(6)));
clase_3 = clase_3(index, :);


nombres = {nombre1; nombre2; nombre3};

continuar = 1;

while(continuar==1)
    disp('Elija un punto para identificar su clase')
    close
    figure(4)
    punto = impixel(imagen)
    
    distancias = [sqrt(sum((punto - media_c1) .^2)) sqrt(sum((punto - media_c2) .^2)) sqrt(sum((punto - media_c3) .^2))]
    
    minimo = min(distancias);
    
    disp(strcat(['La clase a la que pertenece es: ' nombres{find(distancias==minimo)}]))

    plot3(clase_1(:,1),clase_1(:,2),clase_1(:,3),'ro','MarkerSize',10,'MarkerFaceColor','r')
    grid on
    hold on
    plot3(clase_2(:,1),clase_2(:,2),clase_2(:,3),'bo','MarkerSize',10,'MarkerFaceColor','b')
    plot3(clase_3(:,1),clase_3(:,2),clase_3(:,3),'yo','MarkerSize',10,'MarkerFaceColor','y')
    plot3(punto(:,1),punto(:,2),punto(:,3),'ko','MarkerSize',10,'MarkerFaceColor','k')
    legend(nombre1, nombre2, nombre3,'punto')

    continuar = input(['Escriba "1" si quiere identificar la clase de otro punto: ']);
end
close


return