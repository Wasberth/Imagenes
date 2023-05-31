%Compresión huffman

clc
clear all
close all   
warning off all

imagen=imread("peppers.png");
imagen = im2gray(imagen);

tamy = size(imagen, 1);
tamx = size(imagen, 2);

[veces, pixeles] = imhist(imagen);

figure(1)
imshow(imagen)

figure(2)
subplot(1,1,1), bar(pixeles,veces), title("histograma owo");

cantidadNumeros = tamx * tamy;

probabilidades = veces/cantidadNumeros;

pixeles = string(char(pixeles + 1))

tempProb = []
tempPix = []
for i = 1:256
    if(probabilidades(i) ~= 0)
        tempProb = [tempProb probabilidades(i)];
        tempPix = [tempPix pixeles(i)];
    end
end

probabilidades = tempProb'
pixeles = tempPix'

faltan = size(probabilidades);
faltan = faltan(1);

pasosProbabilidades = string(zeros(faltan));
pasosArbol = string(zeros(faltan));

j = 1;
archivo = fopen("resultados.txt", "w");

while(faltan > 1)
    [probabilidades, indicesOrdenados] = sort(probabilidades);
    pixeles = pixeles(indicesOrdenados);
    
    pasosProbabilidades(1:faltan, j) = probabilidades;
    pasosArbol(1:faltan, j) = pixeles;

    newProbabilidad = probabilidades(1) + probabilidades(2);
    newString = strcat(char(257), pixeles(1), pixeles(2));
    
    probabilidades = [probabilidades(3:end); newProbabilidad];
    pixeles = [pixeles(3:end); newString];
    fprintf(archivo,"Paso %d:\n", j);
    fprintf(archivo," %s ",probabilidades);
    fprintf(archivo,"\n");

    faltan = faltan - 1;
    
    j = j + 1;
    
end

arbol = char(pixeles)
longitudArbol = strlength(arbol)

codificacion = string(1:256);
codificacionActual = '';
k = 0;

fprintf(archivo,"\n\nColocar codigos\n\n");

for i = 1 : longitudArbol
    charActual = arbol(i);
    if charActual == char(257)
        k = k + 1;
        codificacionActual(k) = '0';
%         fprintf(archivo," %s ",codificacionActual);
%         fprintf(archivo,"\n\n");
    else 
        codificacion(uint16(charActual)) = string(codificacionActual);
        while(k > 0 && codificacionActual(k) == '1')
            k = k - 1;
            codificacionActual = codificacionActual(1 : k);
%             fprintf(archivo," %s ",codificacionActual);
%             fprintf(archivo,"  ");
        end

        if k > 0
            codificacionActual(k) = '1';
%             fprintf(archivo," %s ",codificacionActual);
%             fprintf(archivo,"\n\n");
        end
    end
end

cantidad = size(tempPix);
cantidad = cantidad(2);

indices = find(veces ~= 0);
codificacionTemp = codificacion(indices);
valores = 0 : 255;
valores = valores(indices);

entropia = 0;
sumLongitudes = 0;
tempProb = tempProb';

for i = 1 : cantidad
    fprintf("Se codifició %d a %s\n", valores(i), codificacionTemp(i));
    fprintf(archivo,"Se codifició %d a %s\n", valores(i), codificacionTemp(i));
    
    entropia = entropia + tempProb(i) * log2(1/tempProb(i));
    sumLongitudes = sumLongitudes + tempProb(i) * strlength(codificacionTemp(i));
end

fprintf("La entropia es %d\n", entropia);
fprintf("La longitud media es %d\n", sumLongitudes)
fprintf("La eficiencia es %d\n", 100*entropia/sumLongitudes)

fclose(archivo);