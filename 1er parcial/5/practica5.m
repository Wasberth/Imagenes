clc
clear all
close all   
warning off all

imagen=imread("../Practica_3/uvas1127.jpg");
%imagen=imread("https://cdn.discordapp.com/attachments/1078736291300114543/1085752948472160256/uvas1127.jpg");
tamy_imagen = size(imagen, 1);
tamx_imagen = size(imagen, 2);

%{
rojo = imagen;
rojo(:,:,2:3) = 0;

verde = imagen;
verde(:,:,1) = 0;
verde(:,:,3) = 0;

azul = imagen;
azul(:,:,1:2) = 0;

%}

rojo = imagen(:,:,1);
%rojo(:,:,2:3) = 0;

verde = imagen(:,:,2);
%verde(:,:,1) = 0;
%verde(:,:,3) = 0;

azul = imagen(:,:,3);
%azul(:,:,1:2) = 0;

Vrojo = imagen;
Vrojo(:,:,2:3) = 0;

Vverde = imagen;
Vverde(:,:,1) = 0;
Vverde(:,:,3) = 0;

Vazul = imagen;
Vazul(:,:,1:2) = 0;

%     histogram(rojo(:,:,1));
%     histogram(verde(:,:,2));
%     histogram(azul(:,:,3));
[veces,pixeles]=imhist(imagen);
[vecesR,pixelesR]=imhist(rojo);
[vecesG,pixelesG]=imhist(verde);
[vecesB,pixelesB]=imhist(azul);

figure(1)
subplot(1,4,1), imshow(imagen), title("Original");
subplot(1,4,2), imshow(Vrojo), title("Rojo");
subplot(1,4,3), imshow(Vverde), title("Verde");
subplot(1,4,4), imshow(Vazul), title("Azul");

figure(2)
subplot(1,3,1), bar(pixelesR,vecesR), title("Rojo con bar");
subplot(1,3,2), bar(pixelesG,vecesG), title("Verde con bar");
subplot(1,3,3), bar(pixelesB,vecesB), title("Azul con bar");

figure(3)
subplot(1,3,1), histogram(Vrojo(:,:,1)), title("Rojo con histogram");
subplot(1,3,2), histogram(Vverde(:,:,2)), title("Verde con histogram");
subplot(1,3,3), histogram(Vazul(:,:,3)), title("Azul con histogram");

continuar = 1;
while(continuar==1)
    bandera = true;
    while(bandera)
        bandera = false;
        mn = input("Ingrese los limites en formato [m, n]: ");
        if(mn(1)<0 | mn(2)>255)
            disp("Datos inválidos, intentelo otra vez");
            bandera = true;
        end
        if(mn(1)>mn(2))
            temp = mn(1);
            mn(1) = mn(2);
            mn(2) = temp;
        end
    end

    for(k = 1:3)
        minimo = min(imagen(:,:,k));
        minimo = min(minimo);
        maximo = max(imagen(:,:,k));
        maximo = max(maximo);
    
        p = double((mn(2)-mn(1)))/double((maximo-minimo));
        b = mn(1) - (double(p)*double(minimo));
    
        imagentmp = imagen(:, :, k);
        for(i = 1:tamy_imagen)
            for(j = 1:tamx_imagen)
                %imagentmp(tamy_imagen, tamx_imagen) = (((imagentmp(tamy_imagen, tamx_imagen)-mn(1))/(mn(2)-mn(1)))*(maximo - minimo))+mn(1);
                imagentmp(i,j) = (imagen(i,j,k)*p)+b;
            end
        end

        imagen(:,:,k) = imagentmp;
    end
    
    %imagentmp = arrayfun(@(x) (((x-minimo)/(maximo-minimo))*(mn(2) - mn(1)))+mn(1), imagentmp)

    close all
    
    rojo = imagen(:,:,1);
    %rojo(:,:,2:3) = 0;
    
    verde = imagen(:,:,2);
    %verde(:,:,1) = 0;
    %verde(:,:,3) = 0;
    
    azul = imagen(:,:,3);
    %azul(:,:,1:2) = 0;

    Vrojo = imagen;
    Vrojo(:,:,2:3) = 0;
    
    Vverde = imagen;
    Vverde(:,:,1) = 0;
    Vverde(:,:,3) = 0;
    
    Vazul = imagen;
    Vazul(:,:,1:2) = 0;

%     histogram(rojo(:,:,1));
%     histogram(verde(:,:,2));
%     histogram(azul(:,:,3));
    [veces,pixeles]=imhist(imagen);
    [vecesR,pixelesR]=imhist(rojo);
    [vecesG,pixelesG]=imhist(verde);
    [vecesB,pixelesB]=imhist(azul);

    figure(1)
    subplot(1,4,1), imshow(imagen), title("Original");
    subplot(1,4,2), imshow(Vrojo), title("Rojo");
    subplot(1,4,3), imshow(Vverde), title("Verde");
    subplot(1,4,4), imshow(Vazul), title("Azul");
    
    figure(2)

    subplot(1,3,1), bar(pixelesR,vecesR), title("Rojo con bar");
    subplot(1,3,2), bar(pixelesG,vecesG), title("Verde con bar");
    subplot(1,3,3), bar(pixelesB,vecesB), title("Azul con bar");

%     figure(3)
%     subplot(1,3,1), histogram(rojo), title("Rojo");
%     subplot(1,3,2), histogram(verde), title("Verde");
%     subplot(1,3,3), histogram(azul), title("Azul");

    figure(4)
    subplot(1,3,1), histogram(Vrojo(:,:,1)), title("Rojo con histogram");
    subplot(1,3,2), histogram(Vverde(:,:,2)), title("Verde con histogram");
    subplot(1,3,3), histogram(Vazul(:,:,3)), title("Azul con histogram");

    continuar = input("¿Desea comprimir/expandir otra vez? (1 = sí): ");
end

close all
return