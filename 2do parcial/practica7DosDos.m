%La buena, pero no la entregamos, solo la corregimos para futura referencia

clc
clear all
close all   
warning off all

bits_a_comprimir = 5;

imagen1=imread("peppers.png");
imagen = rgb2gray(imagen1);

tamy = size(imagen, 1);
tamx = size(imagen, 2);

predicha = double(ones(tamy, tamx)*(-1));

% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

numFilas = input('En cuantas filas desea partir la imagen');
numColumnas = input('En cuantas columnas desea partir la imagen');

tamFilas = ceil(tamy/numFilas);
tamColumnas = ceil(tamx/numColumnas);

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
            predicha(j, bigX + 1) = double(imagen(j, bigX + 1));
        end
        
        for i = (1 + bigX):(bigX + tamColumnas)
            if(i > tamx || bigY + 1 > tamy) 
                break
            end
            predicha(bigY + 1, i) = double(imagen(bigY + 1, i));
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
        
                        valor = predicha(yy, xx);

                        if(isnan(valor))
                            disp("Murio")
                            disp(bigY)
                            disp(bigX)
                            disp(y)
                            disp(x)
                            disp(yy)
                            disp(xx)
                            error();
                        end

                        if(predicha(yy, xx) == -1)
                            cantidadMenosUnos = cantidadMenosUnos + 1;
                            continue;
                        end
        
                        suma = suma + valor;
                    end
        
                    predicha(y, x) = round(suma / (8 - cantidadMenosUnos));
                end
            end
        end
    end
end

predicha
predicha = uint8(predicha);

error = double(imagen) - double(predicha);
errorTemp = uint8(error + 128);

%Pedir al usuario los bits a comprimir
figure(1)
subplot(2, 2, 1), imshow(imagen), title("Original")
subplot(2, 2, 2), imshow(predicha), title("Predicha")
subplot(2, 2, 3), imshow(errorTemp), title("Error")


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

combinaciones = round(2.^bits_a_comprimir);

theta = (e_max - e_min) / (combinaciones);

intervalos = [];
mitades = [];
for k = 1 : combinaciones
    intervalos(k) = e_min + (theta * (k - 1));
    mitades(k) = e_min + (theta * (k - 0.5));
end

valores = e_min : e_max;
cantidadValores = size(valores');

correspondencia = [];
correspondenciaEQ = [];

for i = 1 : cantidadValores
    aux = abs(intervalos - valores(i))';
    minIndex = find(aux(:,1) == min(aux(:,1)));

    inSel = minIndex(1);

    correspondencia(i) = inSel;
    correspondenciaEQ(i) = mitades(inSel);
end

MEQ = arrayfun(@(x) correspondencia(find(valores == x)), error);
MEQ_1 = arrayfun(@(x) correspondenciaEQ(find(valores == x)), error);

recup=[];
for j = 1 : tamy
    for i = 1 : tamx
        recup(j, i) = round(MEQ_1(j, i) + predicha(j, i));
    end
end

recup = uint8(recup);

MEQ = uint8(MEQ);

figure(2)
subplot(2, 2, 1), imshow(imagen), title("Original");
subplot(2, 2, 2), imshow(predicha), title("Predicha");
subplot(2, 2, 3), imshow(MEQ), title("MEQ");
subplot(2, 2, 4), imshow(recup), title("Recuperada");

imagenCuadrada = imagen;
imagenRestaCuadrada = imagen - recup;

for j = 1:tamy
    for i = 1:tamx
        imagenCuadrada(j, i) = imagenCuadrada(j, i) * imagenCuadrada(j, i);
        imagenRestaCuadrada(j, i) = imagenRestaCuadrada(j, i) * imagenRestaCuadrada(j, i);
    end
end

sn = 10*log10(sum(imagenCuadrada ,"all")/sum((imagenRestaCuadrada), "all"))