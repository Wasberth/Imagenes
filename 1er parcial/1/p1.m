%% Figura a) y b) (colores normales y rgb horizontal)
imagen0=imread("peppers.png");
imagen=imread("peppers.png");
tamy_imagen = size(imagen, 1)
tamx_imagen = size(imagen, 2)

% 
% figure(1)
% 
% imshow(imagen)

% rojo=imagen(:, :, 1);
% verde=imagen(:, :, 2);
% azul=imagen(:, :, 3);

imagen(1:round(tamy_imagen/3),:, [2:3])=0;
imagen(round(tamy_imagen/3)+1:2*round(tamy_imagen/3),:,[1,3])=0;
imagen((2*round(tamy_imagen/3))+1:tamy_imagen,:,[1:2])=0;
% figure(2)
% imshow(imagen)


%% Figura c) (rgb vertical)
imagen2=imread("peppers.png");
tamy_imagen2=size(imagen2, 1)
tamx_imagen2=size(imagen2, 2)

imagen2(:, 1:tamx_imagen2/3,[2:3])=0;
imagen2(:,(tamx_imagen2/3)+1:2*tamx_imagen2/3,[1,3])=0;
imagen2(:,(2*tamx_imagen2/3)+1:tamx_imagen2,[1:2])=0;
% figure(3)
% imshow(imagen2)




%%

imagen3=imread("peppers.png");
tamy_imagen3 = size(imagen3, 1)
tamx_imagen3 = size(imagen3, 2)

tamLetra=min(tamy_imagen3, tamx_imagen3)

esquinax = (tamx_imagen2 - tamLetra)/2
esquinay = (tamy_imagen2 - tamLetra)/2


centrox = tamLetra/2 + esquinax
centroy = (2*tamLetra/3)+ esquinay

radioG=tamLetra/3
radioP = tamLetra/12






%%

imagen3=imread("peppers.png");
tamy_imagen3 = size(imagen3, 1)
tamx_imagen3 = size(imagen3, 2)

tamLetra=min(tamy_imagen3, tamx_imagen3)
anchoLetra = 1/5

esquinax = (tamx_imagen3 - tamLetra)/2
esquinay = (tamy_imagen3 - tamLetra)/2

centrox = tamLetra/2 + esquinax
centroy = (2*tamLetra/3)+ esquinay

radioG = tamLetra/3
radioP = tamLetra*((1/3)-anchoLetra)

rect1x = centrox+radioP
rect1y = esquinay

rect2x = rect1x + (tamLetra * anchoLetra);
rect2y = centroy;

for j=1:tamx_imagen3
    for i=1:tamy_imagen3
        distancia=sqrt((j-centrox)^2+(i-centroy)^2);
        %i<(esquinay+tamLetra)*2/3
        if ((j>=rect1x && j<=rect2x && i>=rect1y && i<=rect2y)||(distancia<=radioG && distancia>=radioP && i>=centroy))
            imagen3(i, j, [1,3])=0;
        else
            if j<tamx_imagen3/2
                imagen3(i, j, [2:3])=0;
            else
                imagen3(i, j, [1:2])=0;
            end
        end
        
        

        %if (j>esquinax && i >esquinay && i<(esquinay+tamLetra)*2/3)
        %    imagen3(i, j, [1,3])=0;
        %    imagen3(i, j, [2])=255;
        %    
        %end
        
    end
end

%figure(6)
%imshow(imagen3);


subplot(2,2,1), imshow(imagen0), title("original");
subplot(2,2,2), imshow(imagen), title("Vertical");
subplot(2,2,3), imshow(imagen2), title("Horizontal");
subplot(2,2,4), imshow(imagen3), title("letra J");