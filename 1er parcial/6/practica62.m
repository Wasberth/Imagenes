clc
clear all
close all   
warning off all

rojo=imread("peppers.png");
verde=imread("peppers.png");
grisVerde=imread("peppers.png");
gris=imread("peppers.png");

rojo(:,:, [2:3])=0;
verde(:,:,[1,3])=0;
grisVerde=grisVerde(:,:,3);
gris=rgb2gray(gris);

im1 = imfuse(gris, verde, "montage");
im2 = imfuse(rojo, grisVerde, "montage");

%imagen1 = [im1;im2];

imagen1=imread("../examen/img.jpg");
tamy_imagen1 = size(imagen1, 1)
tamx_imagen1 = size(imagen1, 2)

imagen2=imread("../examen/figura.jpg");
tamy_imagen2 = size(imagen2, 1)
tamx_imagen2 = size(imagen2, 2)

    
%imagentmp = arrayfun(@(x) (((x-minimo)/(maximo-minimo))*(mn(2) - mn(1)))+mn(1), imagentmp

% Para histograma 1

rojo1 = imagen1(:,:,1);
verde1 = imagen1(:,:,2);
azul1 = imagen1(:,:,3);

Vrojo1 = imagen1;
Vrojo1(:,:,2:3) = 0;

Vverde1 = imagen1;
Vverde1(:,:,1) = 0;
Vverde1(:,:,3) = 0;

Vazul1 = imagen1;
Vazul1(:,:,1:2) = 0;

% Para histograma 2

rojo2 = imagen2(:,:,1);
verde2 = imagen2(:,:,2);
azul2 = imagen2(:,:,3);

Vrojo2 = imagen2;
Vrojo2(:,:,2:3) = 0;

Vverde2 = imagen2;
Vverde2(:,:,1) = 0;
Vverde2(:,:,3) = 0;

Vazul2 = imagen2;
Vazul2(:,:,1:2) = 0;

%     histogram(rojo(:,:,1));
%     histogram(verde(:,:,2));
%     histogram(azul(:,:,3));
[veces1,pixeles1]=imhist(imagen1);
[vecesR1,pixelesR1]=imhist(rojo1);
[vecesG1,pixelesG1]=imhist(verde1);
[vecesB1,pixelesB1]=imhist(azul1);

[veces2,pixeles2]=imhist(imagen2);
[vecesR2,pixelesR2]=imhist(rojo2);
[vecesG2,pixelesG2]=imhist(verde2);
[vecesB2,pixelesB2]=imhist(azul2);

figure(1)
subplot(2,2,1), imshow(imagen1), title("Imagen 1");
subplot(2,2,2), imshow(Vrojo1), title("Rojo");
subplot(2,2,3), imshow(Vverde1), title("Verde");
subplot(2,2,4), imshow(Vazul1), title("Azul");

figure(2)
subplot(2,2,1), imshow(imagen2), title("Imagen 2");
subplot(2,2,2), imshow(Vrojo2), title("Rojo");
subplot(2,2,3), imshow(Vverde2), title("Verde");
subplot(2,2,4), imshow(Vazul2), title("Azul");

figure(3)
subplot(1,4,1), bar(pixeles1,veces1), title("Imagen 1 con bar");
subplot(1,4,2), bar(pixelesR1,vecesR1), title("Rojo con bar");
subplot(1,4,3), bar(pixelesG1,vecesG1), title("Verde con bar");
subplot(1,4,4), bar(pixelesB1,vecesB1), title("Azul con bar");

figure(4)
subplot(1,4,1), bar(pixeles2,veces2), title("Imagen 2 con bar");
subplot(1,4,2), bar(pixelesR2,vecesR2), title("Rojo con bar");
subplot(1,4,3), bar(pixelesG2,vecesG2), title("Verde con bar");
subplot(1,4,4), bar(pixelesB2,vecesB2), title("Azul con bar");

%     figure(3)
%     subplot(1,3,1), histogram(rojo), title("Rojo");
%     subplot(1,3,2), histogram(verde), title("Verde");
%     subplot(1,3,3), histogram(azul), title("Azul");
%{
figure(4)
subplot(1,4,1), histogram(imagen), title("Original");
subplot(1,4,2), histogram(Vrojo(:,:,1)), title("Rojo");
subplot(1,4,3), histogram(Vverde(:,:,2)), title("Verde");
subplot(1,4,4), histogram(Vazul(:,:,3)), title("Azul");
%}    

veces1 = [vecesR1 vecesG1 vecesB1]
veces2 = [vecesR2 vecesG2 vecesB2]

figure(5)
subplot(1,2,1), imshow(imagen1), title("Imagen 1");
subplot(1,2,2), imshow(imagen2), title("Imagen 2");

Ng1 = veces1';
Ng2 = veces2';
sumaNg1 = [sum(Ng1(1, :)) sum(Ng1(2, :)) sum(Ng1(3, :))];
sumaNg2 = [sum(Ng2(1, :)) sum(Ng2(2, :)) sum(Ng2(3, :))];

Pg1=[];
PgAcum1=[];

Pg2=[];
PgAcum2=[];

for i = 1 : size(Ng1, 2)
    for k = 1 : 3
        Pg1(k, i) = double(Ng1(k, i)) / double(sumaNg1(k));
    end
    if i == 1
        PgAcum1(:, i) = Pg1(:, i);
    else
        PgAcum1(:, i) = Pg1(:,i) + PgAcum1(:,i-1);
    end
end

for i = 1 : size(Ng2, 2)
    for k = 1 : 3
        Pg2(k, i) = double(Ng2(k, i)) / double(sumaNg2(k));
    end
    if i == 1
        PgAcum2(:, i) = Pg2(:, i);
    else
        PgAcum2(:, i) = Pg2(:,i) + PgAcum2(:,i-1);
    end
end

correspondencia=[];
for i = 1 : size(PgAcum2, 2)
    aux = abs(PgAcum1 - PgAcum2(i))';

    minIndexR = find(aux(:,1) == min(aux(:,1)))
    minIndexG = find(aux(:,2) == min(aux(:,2)))
    minIndexB = find(aux(:,3) == min(aux(:,3)))

    correspondencia(1, i) = minIndexR(1);
    correspondencia(2, i) = minIndexG(1);
    correspondencia(3, i) = minIndexB(1);
end

%imagen(1,1)
%imagentmp = imagen(:, :, k);
for(i = 1:tamy_imagen2)
    for(j = 1:tamx_imagen2)
        valor = imagen2(i,j) + 1;
        imagen2(i, j, 1) = correspondencia(1, valor);
        imagen2(i, j, 2) = correspondencia(2, valor);
        imagen2(i, j, 3) = correspondencia(3, valor);
    end
end

rojo = imagen2(:,:,1);
%rojo(:,:,2:3) = 0;

verde = imagen2(:,:,2);
%verde(:,:,1) = 0;
%verde(:,:,3) = 0;

azul = imagen2(:,:,3);
%azul(:,:,1:2) = 0;

Vrojo = imagen2;
Vrojo(:,:,2:3) = 0;

Vverde = imagen2;
Vverde(:,:,1) = 0;
Vverde(:,:,3) = 0;

Vazul = imagen2;
Vazul(:,:,1:2) = 0;

figure(234)
subplot(1,4,1), histogram(imagen2), title("Correspondiente");
subplot(1,4,2), histogram(Vrojo(:,:,1)), title("Rojo");
subplot(1,4,3), histogram(Vverde(:,:,2)), title("Verde");
subplot(1,4,4), histogram(Vazul(:,:,3)), title("Azul");

figure(6)
subplot(1,1,1), imshow(imagen2), title("Correspondiente");


%close all
%return