clc
clear all
close all   
warning off all

imagen=imread("sherlock.jpg");
tamy_imagen = size(imagen, 1)
tamx_imagen = size(imagen, 2)

rojo = imagen;
rojo(:,:,2:3) = 0;

verde = imagen;
verde(:,:,1) = 0;
verde(:,:,3) = 0;

azul = imagen;
azul(:,:,1:2) = 0;

figure(1)
subplot(1,4,1), imshow(imagen), title("Original");
subplot(1,4,2), imshow(rojo), title("Rojo");
subplot(1,4,3), imshow(verde), title("Verde");
subplot(1,4,4), imshow(azul), title("Azul");

figure(2)
subplot(1,3,1), histogram(rojo(:,:,1)), title("Rojo");
subplot(1,3,2), histogram(verde(:,:,2)), title("Verde");
subplot(1,3,3), histogram(azul(:,:,3)), title("Azul");

continuar = 1;
while(continuar==1)

    mn = input("Ingrese los limites en formato [m, n]: ");

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
        display("imagen original");
        imagen(1,1,k)
        display("imagen temporal");
        imagen(1,1)
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
    subplot(1,4,1), bar(pixeles,veces), title("Original con bar");
    subplot(1,4,2), bar(pixelesR,vecesR), title("Rojo con bar");
    subplot(1,4,3), bar(pixelesG,vecesG), title("Verde con bar");
    subplot(1,4,4), bar(pixelesB,vecesB), title("Azul con bar");

%     figure(3)
%     subplot(1,3,1), histogram(rojo), title("Rojo");
%     subplot(1,3,2), histogram(verde), title("Verde");
%     subplot(1,3,3), histogram(azul), title("Azul");

    figure(4)
    subplot(1,4,1), histogram(imagen), title("Original");
    subplot(1,4,2), histogram(Vrojo(:,:,1)), title("Rojo");
    subplot(1,4,3), histogram(Vverde(:,:,2)), title("Verde");
    subplot(1,4,4), histogram(Vazul(:,:,3)), title("Azul");
    

    figure(5)
    subplot(1,1,1), imshow(imagen), title("Original");
    
    
    %Ecualizacion
    minCE = mn(1)
    maxCE= mn(2)
    g=[minCE:maxCE]
    %
    [vecesC,pixelesC]=imhist(imagen);
    %histogramaH = histogram(imagen);
    %valores del histograma

    %Ng = histogramaH.Values
    Ng = vecesC'
    sumaNg = sum(Ng)
    size(Ng, 2)
    
    Pg=[];
    PgAcum=[];
    for i=1:size(Ng, 2)
        Pg=[Pg;Ng(i)/sumaNg];
        aux=cumsum(Pg);
        PgAcum = [PgAcum;aux(end)];
        %190763      296774      392687      288947     1230829
%         0.0795
    %     0.2031
    %     0.3668
    %     0.4872
    %     1.0000
%     0.3179
%     0.8126
%     1.4670
%     1.9486
%     4.0000
    end
    ProbaG = Pg
    ProbaAcum = PgAcum
    ecualizacion=[];
    for i=1:size(ProbaAcum,1)
        aux=round((maxCE-minCE)*(ProbaAcum(i))+minCE);
        ecualizacion=[ecualizacion; aux];
    end
    %imagen(1,1)
    %imagentmp = imagen(:, :, k);
    
    for(i = 1:tamy_imagen)
        for(j = 1:tamx_imagen)
            index = find(g==imagen(i,j));
            
            if index==maxCE-minCE+1
                index=index-2;
            elseif index==0
                index=index+1;
            else
                index=index;
            end
              
            imagen(i,j) = ecualizacion(index);
        end
    end

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

    figure(234)
    subplot(1,4,1), histogram(imagen), title("Ecualizada");
    subplot(1,4,2), histogram(Vrojo(:,:,1)), title("Rojo");
    subplot(1,4,3), histogram(Vverde(:,:,2)), title("Verde");
    subplot(1,4,4), histogram(Vazul(:,:,3)), title("Azul");

    figure(6)
    subplot(1,1,1), imshow(imagen), title("Ecualizada");
    continuar = input("¿Desea comprimir/expandir otra vez?: ");
end

close all
return