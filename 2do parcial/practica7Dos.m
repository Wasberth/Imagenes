%con predicción que no le gustó al profesor, pero está oculta

clc
clear all
close all   
warning off all

bits_a_comprimir = 5;

imagen1=imread("peppers.png");
imagen = rgb2gray(imagen1);

tamy = size(imagen, 1);
tamx = size(imagen, 2);


predicha = double(zeros(tamy, tamx));

for j = 1:tamy
    predicha(j, 1) = double(imagen(j, 1));
end

for i = 1:tamx
    predicha(1, i) = double(imagen(1, i));
end

for j = 2:tamy
    for i = 2:tamx
        predicha(j, i) = -1;
    end
end

predicha2 = double(zeros(tamy, tamx));

for j = 1:tamy
    predicha2(j, 1) = double(imagen(j, 1));
end

for i = 1:tamx
    predicha2(1, i) = double(imagen(1, i));
end

for j = 2:tamy
    for i = 2:tamx
        predicha2(j, i) = -1;
    end
end

secciones_y = round((tamy - 1) / (2));
secciones_x = round((tamx - 1) / (2));

% coordenadas relativas en px para los cuadros adyacentes
crpAdj1 = [-1, -1; -1, 1; -1, 0; 0, -1; 1, -1];
crpAdj2 = [-1, -1; -1, 0; -1, 1; 0, 1; 1, 1];
crpAdj3 = [-1, -1; 0, -1; 1, -1; 1, 0; 1, 1];
crpAdj4 = [-1, 1; 0, 1; 1, -1; 1, 0; 1, 1];

for j = 1:secciones_y
    for i = 1:secciones_x
        y = j*2;
        x = i*2;

        valor1 = [];
        valor2 = [];
        valor3 = [];
        valor4 = [];
        cuenta = [0, 0, 0, 0];
        for n = 1:5
            yy1 = y + crpAdj1(n, 1);
            xx1 = x + crpAdj1(n, 2);
            yy2 = y + crpAdj2(n, 1);
            xx2 = x + crpAdj2(n, 2);
            yy3 = y + crpAdj3(n, 1);
            xx3 = x + crpAdj3(n, 2);
            yy4 = y + crpAdj4(n, 1);
            xx4 = x + crpAdj4(n, 2);

            if(yy1 <= tamy && xx1 <= tamx)
                cuenta(1) = cuenta(1) + 1;
                valor1(cuenta(1)) = imagen(yy1, xx1);
            end
            if(yy2 <= tamy && xx2 <= tamx)
                cuenta(2) = cuenta(2) + 1;
                valor2(cuenta(2)) = imagen(yy2, xx2);
            end
            if(yy3 <= tamy && xx3 <= tamx)
                cuenta(3) = cuenta(3) + 1;
                valor3(cuenta(3)) = imagen(yy3, xx3);
            end
            if(yy4 <= tamy && xx4 <= tamx)
                cuenta(4) = cuenta(4) + 1;
                valor4(cuenta(4)) = imagen(yy4, xx4);
            end

        end

        existeB2 = x + 1 <= tamx;
        existeB3 = y + 1 <= tamy;
        existeB4 = x + 1 <= tamx && y + 1 <= tamy;

        b1 = mean(valor1);
        predicha2(y, x) = b1;
        if existeB2
            b2 = mean([valor2, b1], 'all');
            predicha2(y, x+1) = b2;

            valor3(cuenta(3)+1) = b2;
        end
        if existeB3
            b3 = mean([valor3, b1], 'all');
            predicha2(y+1, x) = b3;
        end
        if existeB4
            b4 = mean([valor4, b1, b2, b3], "all");
            predicha2(y+1, x+1) = b4;
        end
    end
end

predicha2 = uint8(predicha2);


error2 = double(imagen) - double(predicha2);

errorTemp = uint8(error2 + 128);

% coordenadas relativas en px para los cuadros adyacentes
crpAdj = [-1, -1; -1, 0; -1, 1; 0, -1; 0, 1; 1, -1; 1, 0; 1, 1];

% coordenadas relativas en px de b1, b2, b3 y b4
coordsB = [0, 0; 0, 1; 1, 0; 1, 1];

for j = 1:secciones_y
    for i = 1:secciones_x
        for k = 1:4
            y = j*2 + coordsB(k, 1);
            x = i*2 + coordsB(k, 2);

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
predicha = uint8(predicha);

error = double(imagen) - double(predicha);


%Pedir al usuario los bits a comprimir
figure(1)
subplot(2, 2, 1), imshow(imagen), title("Original")
subplot(2, 2, 2), imshow(predicha2), title("Predicha")
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
subplot(2, 2, 2), imshow(predicha2), title("Predicha");
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