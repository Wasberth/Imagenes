%Compresión con TCD (transformada coseno discreta)

clc
clear all
close all   
warning off all

imagen=imread("peppers.png");
imagen = im2gray(imagen);

tamy = size(imagen, 1);
tamx = size(imagen, 2);

%Redimensionar la imagen a multiplos de 8
tamx8 = tamx - (mod(tamx,8));
tamy8 = tamy - (mod(tamy,8));

imagen8 = zeros(tamy8, tamx8);
imagen8 = imagen(1:tamy8, 1:tamx8);

%Transformada coseno
imagenCoseno = dct2(imagen8);

%Consiguiendo la matriz para la primera prediccion
tempx = [1, ((1:(tamx8/8)-1)*8)+1];
tempy = [1, ((1:(tamy8/8)-1)*8)+1];
predicha1 = imagenCoseno(tempy, tempx);

%Consiguiendo la matriz para la segundo prediccion
tempx = [];
cont = 1;
ind = 1;

for i=1:tamx8
    if(mod(i, 8)~=0)
        tempx(ind) = cont;
        ind = ind + 1;
    end
    cont = cont+1;
end

predicha2 = imagenCoseno(tempy, tempx);

%Consiguiendo la matriz para la tercera prediccion
tempx = [1, ((1:(tamx8/8)-1)*8)+1];
tempy = [];
cont = 1;
ind = 1;

for i=1:tamy8
    if(mod(i,8)~=0)
        tempy(ind) = cont;
        ind=ind+1;
    end
    cont = cont+1;
end

predicha3 = imagenCoseno(tempy, tempx);

%Consiguiendo la matriz para la cuarta prediccion
tempx = [];
cont = 1;
ind = 1;

for i=1:tamx8
    if(mod(i, 8)~=0)
        tempx(ind) = cont;
        ind = ind + 1;
    end
    cont = cont+1;
end

predicha4 = imagenCoseno(tempy, tempx);

corte1 = predicha1;
corte2 = predicha2;
corte3 = predicha3;
corte4 = predicha4;
predicha1 = nan(tamy8/8, tamx8/8) * (-1);
predicha2 = nan(tamy8/8, (tamx8*7)/8) * (-1);
predicha3 = nan((tamy8*7)/8, tamx8/8) * (-1);
predicha4 = nan((tamy8*7)/8, (tamx8*7)/8) * (-1);

%Predichacionalizacion la primera prediccion
% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

division = 8;

numFilas = ceil((tamy8/8)/division);
numColumnas = ceil((tamx8/8)/division);

tamFilas = ceil((tamy8/8)/numFilas);
tamColumnas = ceil((tamx8/8)/numColumnas);

tamy = tamy8/8;
tamx = tamx8/8;



numBsEnFilas = round((tamFilas - 1) / 2);
numBsEnColumnas = round((tamColumnas - 1) / 2);

for bigJ = 0 : numFilas - 1
    for bigI = 0 : numColumnas - 1

        bigY = bigJ * tamFilas;
        bigX = bigI * tamColumnas;

        if(bigX > tamx || bigY > tamy)
            continue;
        end
        
        for j = (1 + bigY):(bigY + tamFilas)
            if(j > tamy || bigX + 1 > tamx) 
                break
            end
            predicha1(j, bigX + 1) = double(corte1(j, bigX + 1));
        end
        
        for i = (1 + bigX):(bigX + tamColumnas)
            if(i > tamx || bigY + 1 > tamy) 
                break
            end
            predicha1(bigY + 1, i) = double(corte1(bigY + 1, i));
        end

        for j = 1:numBsEnFilas
            for i = 1:numBsEnColumnas
                for k = 1:4
                    y = j*2 + coordsB(k, 1) + bigY;
                    x = i*2 + coordsB(k, 2) + bigX;
        
                    if(x > tamx || y > tamy)
                        continue;
                    end
        
                    cantidadMenosUnos = 0;
                    suma = 0;
                    for n = 1:8
                        yy = y + crpAdj(n, 1);
                        xx = x + crpAdj(n, 2);
        
                        if(yy > tamy || xx > tamx)
                            continue;
                        end
            
                        valor = predicha1(yy, xx);
% 
%                         if(isnan(valor))
%                             disp("Murio")
%                             disp(bigY)
%                             disp(bigX)
%                             disp(y)
%                             disp(x)
%                             disp(yy)
%                             disp(xx)
%                             error();
%                         end

                        if(isnan(predicha1(yy, xx)))
                            cantidadMenosUnos = cantidadMenosUnos + 1;
                            continue;
                        end
        
                        suma = suma + valor;
                    end
        
                    predicha1(y, x) = suma / (8 - cantidadMenosUnos);
                end
            end
        end
    end
end

%Predichacionalizacion la segunda prediccion
% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

%Cambiar tamaños aquí
numFilas = ceil((tamy8/8)/division);
numColumnas = ceil(((tamx8*7)/8)/division);

tamFilas = ceil((tamy8/8)/numFilas);
tamColumnas = ceil(((tamx8*7)/8)/numColumnas);


numBsEnFilas = round((tamFilas - 1) / 2);
numBsEnColumnas = round((tamColumnas - 1) / 2);

tamy = tamy8/8;
tamx = (tamx8*7)/8;

for bigJ = 0 : numFilas - 1
    for bigI = 0 : numColumnas - 1

        bigY = bigJ * tamFilas;
        bigX = bigI * tamColumnas;

        if(bigX > tamx || bigY > tamy)
            continue;
        end
        
        for j = (1 + bigY):(bigY + tamFilas)
            if(j > tamy || bigX + 1 > tamx) 
                break
            end
            predicha2(j, bigX + 1) = double(corte2(j, bigX + 1));
        end
        
        for i = (1 + bigX):(bigX + tamColumnas)
            if(i > tamx || bigY + 1 > tamy) 
                break
            end
            predicha2(bigY + 1, i) = double(corte2(bigY + 1, i));
        end

        for j = 1:numBsEnFilas
            for i = 1:numBsEnColumnas
                for k = 1:4
                    y = j*2 + coordsB(k, 1) + bigY;
                    x = i*2 + coordsB(k, 2) + bigX;
        
                    if(x > tamx || y > tamy)
                        continue;
                    end
        
                    cantidadMenosUnos = 0;
                    suma = 0;
                    for n = 1:8
                        yy = y + crpAdj(n, 1);
                        xx = x + crpAdj(n, 2);
        
                        if(yy > tamy || xx > tamx)
                            continue;
                        end
            
                        valor = predicha2(yy, xx);

%                         if(isnan(valor))
%                             disp("Murio")
%                             disp(bigY)
%                             disp(bigX)
%                             disp(y)
%                             disp(x)
%                             disp(yy)
%                             disp(xx)
%                             error();
%                         end

                        if(isnan(predicha2(yy, xx)))
                            cantidadMenosUnos = cantidadMenosUnos + 1;
                            continue;
                        end
        
                        suma = suma + valor;
                    end
        
                    predicha2(y, x) = suma / (8 - cantidadMenosUnos);
                end
            end
        end
    end
end

%Predichacionalizacion la tercera prediccion
% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

numFilas = ceil(((tamy8*7)/8)/division);
numColumnas = ceil((tamx8/8)/division);

tamFilas = ceil(((tamy8*7)/8)/numFilas);
tamColumnas = ceil((tamx8/8)/numColumnas);


numBsEnFilas = round((tamFilas - 1) / 2);
numBsEnColumnas = round((tamColumnas - 1) / 2);

tamy = (tamy8*7)/8;
tamx = tamx8/8;

for bigJ = 0 : numFilas - 1
    for bigI = 0 : numColumnas - 1

        bigY = bigJ * tamFilas;
        bigX = bigI * tamColumnas;

        if(bigX > tamx || bigY > tamy)
            continue;
        end
        
        for j = (1 + bigY):(bigY + tamFilas)
            if(j > tamy || bigX + 1 > tamx) 
                break
            end
            predicha3(j, bigX + 1) = double(corte3(j, bigX + 1));
        end
        
        for i = (1 + bigX):(bigX + tamColumnas)
            if(i > tamx || bigY + 1 > tamy) 
                break
            end
            predicha3(bigY + 1, i) = double(corte3(bigY + 1, i));
        end

        for j = 1:numBsEnFilas
            for i = 1:numBsEnColumnas
                for k = 1:4
                    y = j*2 + coordsB(k, 1) + bigY;
                    x = i*2 + coordsB(k, 2) + bigX;
        
                    if(x > tamx || y > tamy)
                        continue;
                    end
        
                    cantidadMenosUnos = 0;
                    suma = 0;
                    for n = 1:8
                        yy = y + crpAdj(n, 1);
                        xx = x + crpAdj(n, 2);
        
                        if(yy > tamy || xx > tamx)
                            continue;
                        end
            
                        valor = predicha3(yy, xx);

%                         if(isnan(valor))
%                             disp("Murio")
%                             disp(bigY)
%                             disp(bigX)
%                             disp(y)
%                             disp(x)
%                             disp(yy)
%                             disp(xx)
%                             error();
%                         end

                        if(isnan(predicha3(yy, xx)))
                            cantidadMenosUnos = cantidadMenosUnos + 1;
                            continue;
                        end
        
                        suma = suma + valor;
                    end
        
                    predicha3(y, x) = suma / (8 - cantidadMenosUnos);
                end
            end
        end
    end
end

%Predichacionalizacion la cuatro prediccion
% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

numFilas = ceil(((tamy8*7)/8)/division);
numColumnas = ceil(((tamx8*7)/8)/division);

tamFilas = ceil(((tamy8*7)/8)/numFilas);
tamColumnas = ceil(((tamx8*7)/8)/numColumnas);


numBsEnFilas = round((tamFilas - 1) / 2);
numBsEnColumnas = round((tamColumnas - 1) / 2);

tamy = (tamy8*7)/8;
tamx = (tamx8*7)/8;

for bigJ = 0 : numFilas - 1
    for bigI = 0 : numColumnas - 1

        bigY = bigJ * tamFilas;
        bigX = bigI * tamColumnas;

        if(bigX > tamx || bigY > tamy)
            continue;
        end
        
        for j = (1 + bigY):(bigY + tamFilas)
            if(j > tamy || bigX + 1 > tamx) 
                break
            end
            predicha4(j, bigX + 1) = double(corte4(j, bigX + 1));
        end
        
        for i = (1 + bigX):(bigX + tamColumnas)
            if(i > tamx || bigY + 1 > tamy) 
                break
            end
            predicha4(bigY + 1, i) = double(corte4(bigY + 1, i));
        end

        for j = 1:numBsEnFilas
            for i = 1:numBsEnColumnas
                for k = 1:4
                    y = j*2 + coordsB(k, 1) + bigY;
                    x = i*2 + coordsB(k, 2) + bigX;
        
                    if(x > tamx || y > tamy)
                        continue;
                    end
        
                    cantidadMenosUnos = 0;
                    suma = 0;
                    for n = 1:8
                        yy = y + crpAdj(n, 1);
                        xx = x + crpAdj(n, 2);
        
                        if(yy > tamy || xx > tamx)
                            continue;
                        end
            
                        valor = predicha4(yy, xx);

%                         if(isnan(valor))
%                             disp("Murio")
%                             disp(bigY)
%                             disp(bigX)
%                             disp(y)
%                             disp(x)
%                             disp(yy)
%                             disp(xx)
%                             error();
%                         end

                        if(isnan(predicha4(yy, xx)))
                            cantidadMenosUnos = cantidadMenosUnos + 1;
                            continue;
                        end
        
                        suma = suma + valor;
                    end
        
                    predicha4(y, x) = suma / (8 - cantidadMenosUnos);
                end
            end
        end
    end
end

tamy = tamy8;
tamx = tamx8;

%Devolviendo las predicciones a sus pocisiones en una sola matriz
predichag = zeros(tamy8, tamx8);

for i=1:tamx8
    for j=1:tamy8
        if(mod(i-1,8)==0 && mod(j-1,8)==0)
            predichag(j,i) = predicha1((j+7)/8, (i+7)/8);
        else
            if(mod(j-1,8)==0)
                predichag(j,i) = predicha2((j+7)/8, i-(ceil(i/8)));
            elseif (mod(i-1,8)==0)
                predichag(j, i) = predicha3(j-(ceil(j/8)), (i+7)/8);
            else
                predichag(j, i) = predicha4(j-(ceil(j/8)), i-(ceil(i/8)));
            end
        end
    end
end

error = double(imagenCoseno) - double(predichag);

bits_a_comprimir = 5;

tamal = true;
while(tamal)
    bits_a_comprimir = input("¿A cuántos bits quiere comprimirlo?: ");
    tamal = bits_a_comprimir < 1 || bits_a_comprimir > 7;

    if(tamal)
        disp("Por favor ingrese un valor entre 1 y 7");
    end
end
close all


e_min = min(error,[],'all');
e_max = max(error,[],'all');

combinaciones = round(2.^(bits_a_comprimir*2));

theta = (e_max - e_min) / (combinaciones);

intervalos = [];
mitades = [];
for k = 1 : combinaciones
    intervalos(k) = e_min + (theta * (k - 1));
    mitades(k) = e_min + (theta * (k - 0.5));
end

valores = unique(error);
cantidadValores = size(valores);

correspondencia = [];
correspondenciaEQ = [];
MEQ_1 = zeros(tamy8, tamx8);

for i=1:tamx8
    for j = 1:tamy8
%for i = 1 : cantidadValores
    aux = abs(intervalos - error(j,i))';
    minIndex = find(aux(:,1) == min(aux(:,1)));

    inSel = minIndex(1);

    MEQ_1(j, i) = mitades(inSel);

    %correspondencia(i) = inSel;
    %correspondenciaEQ(i) = mitades(inSel);

    end
end

%MEQ = arrayfun(@(x) correspondencia(find(valores == x)), error);
%MEQ_1 = arrayfun(@(x) correspondenciaEQ(find(valores == x)), error);

recup=[];
for j = 1 : tamy
    for i = 1 : tamx
        recup(j, i) = round(MEQ_1(j, i) + predichag(j, i));
    end
end

recupCosenont = uint8(idct2(recup));

figure(1)
subplot(1, 2, 1), imshow(imagen8), title("Original");
subplot(1, 2, 2), imshow(recupCosenont), title("Recuperada");




imagenCuadrada = imagen8;
imagenRestaCuadrada = imagen8 - recupCosenont;

for j = 1:tamy
    for i = 1:tamx
        imagenCuadrada(j, i) = imagenCuadrada(j, i) * imagenCuadrada(j, i);
        imagenRestaCuadrada(j, i) = imagenRestaCuadrada(j, i) * imagenRestaCuadrada(j, i);
    end
end

sn = 10*log10(sum(imagenCuadrada ,"all")/sum((imagenRestaCuadrada), "all"))
