%Compresión JPG (zig, zag) con tablas

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

cachos = reshape(imagen8,8,8,[]);

osho = input("¿Qué 8x8 quiere?: ");

bloque = cachos(:, :, osho);
if osho ~= 1
    bloque2 = cachos(:, :, osho - 1);
else
    bloque2 = zeros(8, 8);
end

bloqueCoseno = dct2(double(bloque) - 128);
bloqueCoseno2 = dct2(double(bloque2) - 128);

tablaDivisora = double([
    16, 11, 10, 16,  24,  40,  51,  61;
    12, 12, 14, 19,  26,  58,  60,  55;
    14, 13, 16, 24,  40,  57,  69,  56;
    14, 17, 22, 29,  51,  87,  80,  62;
    18, 22, 37, 56,  68, 109, 103,  77;
    24, 35, 55, 64,  81, 104, 113,  92;
    49, 64, 78, 87, 103, 121, 120, 101;
    72, 92, 95, 98, 112, 100, 103,  99
]);

for i = 1 : 8
    for j = 1 : 8
        bloqueDivisor(j, i) = round(bloqueCoseno(j, i) / tablaDivisora(j, i));
        bloqueDivisor2(j, i) = round(bloqueCoseno2(j, i) / tablaDivisora(j, i));
    end
end

%paso 6

if osho ~= 0
    bloqueDivisor(1, 1) = bloqueDivisor(1, 1) - bloqueDivisor2(1 ,1);
end

bloqueCategoria = zeros(8,8);

for i = 1 : 8
    for j = 1 : 8
        if(bloqueDivisor(j, i) == 0)
            bloqueCategoria(j, i) = 0;
        else
            bloqueCategoria(j, i) = floor(log2(abs(bloqueDivisor(j, i)))) + 1;
        end
    end
end

codigo = dec2bin(bloqueDivisor(1, 1));

if (bloqueCategoria(1, 1) == 0)
    codigo = strcat("010", codigo);
elseif (bloqueCategoria(1, 1) == 1)
    codigo = strcat("011", codigo);
elseif (bloqueCategoria(1, 1) == 2)
    codigo = strcat("100", codigo);
elseif (bloqueCategoria(1, 1) == 3)
    codigo = strcat("00", codigo);
elseif (bloqueCategoria(1, 1) == 4)
    codigo = strcat("101", codigo);
elseif (bloqueCategoria(1, 1) == 5)
    codigo = strcat("110", codigo);
elseif (bloqueCategoria(1, 1) == 6)
    codigo = strcat("1110", codigo);
elseif (bloqueCategoria(1, 1) == 7)
    codigo = strcat("11110", codigo);
elseif (bloqueCategoria(1, 1) == 8)
    codigo = strcat("111110", codigo);
elseif (bloqueCategoria(1, 1) == 9)
    codigo = strcat("1111110", codigo);
elseif (bloqueCategoria(1, 1) == 10)
    codigo = strcat("11111110", codigo);
elseif (bloqueCategoria(1, 1) == 11)
    codigo = strcat("111111110", codigo);
end

bloqueBinario = strings(8,8);
bloqueBinario(1,1) = codigo;

tablaAc = [
    "00","01","100","1011","11010","1111000","11111000","1111110110","1111111110000010","1111111110000011";
    "1100","11011","1111001","111110110","11111110110","1111111110000100","1111111110000101","1111111110000110","1111111110000111","1111111110001000";
    "11100","11111001","1111110111","111111110100","1111111110001001","1111111110001010","1111111110001011","1111111110001100","1111111110001101","1111111110001110";
    "111010","111110111","111111110101","1111111110001111","1111111110010000","1111111110010001","1111111110010010","1111111110010011","1111111110010100","1111111110010101";
    "111011","1111111000","1111111110010110","1111111110010111","1111111110011000","1111111110011001","1111111110011010","1111111110011011","1111111110011100","1111111110011101";
    "1111010","11111110111","1111111110011110","1111111110011111","1111111110100000","1111111110100001","1111111110100010","1111111110100011","1111111110100100","1111111110100101";
    "1111011","111111110110","1111111110100110","1111111110100111","1111111110101000","1111111110101001","1111111110101010","1111111110101011","1111111110101100","1111111110101101";
    "11111010","111111110111","1111111110101110","1111111110101111","1111111110110000","1111111110110001","1111111110110010","1111111110110011","1111111110110100","1111111110110101";
    "111111000","111111111000000","1111111110110110","1111111110110111","1111111110111000","1111111110111001","1111111110111010","1111111110111011","1111111110111100","1111111110111101";
    "111111001","1111111110111110","1111111110111111","1111111111000000","1111111111000001","1111111111000010","1111111111000011","1111111111000100","1111111111000101","1111111111000110";
    "111111010","1111111111000111","1111111111001000","1111111111001001","1111111111001010","1111111111001011","1111111111001100","1111111111001101","1111111111001110","1111111111001111";
    "1111111001","1111111111010000","1111111111010001","1111111111010010","1111111111010011","1111111111010100","1111111111010101","1111111111010110","1111111111010111","1111111111011000";
    "1111111010","1111111111011001","1111111111011010","1111111111011011","1111111111011100","1111111111011101","1111111111011110","1111111111011111","1111111111100000","1111111111100001";
    "11111111000","1111111111100010","1111111111100011","1111111111100100","1111111111100101","1111111111100110","1111111111100111","1111111111101000","1111111111101001","1111111111101010";
    "1111111111101011","1111111111101100","1111111111101101","1111111111101110","1111111111101111","1111111111110000","1111111111110001","1111111111110010","1111111111110011","1111111111110100";
    "1111111111110101","1111111111110110","1111111111110111","1111111111111000","1111111111111001","1111111111111010","1111111111111011","1111111111111100","1111111111111101","1111111111111110"
];

tamAc = [2,2,3,4,5,7,8,10,16,16;
4,5,7,9,11,16,16,16,16,16;
5,8,10,12,16,16,16,16,16,16;
6,9,12,16,16,16,16,16,16,16;
6,10,16,16,16,16,16,16,16,16;
7,11,16,16,16,16,16,16,16,16;
7,12,16,16,16,16,16,16,16,16;
8,12,16,16,16,16,16,16,16,16;
9,15,16,16,16,16,16,16,16,16;
9,16,16,16,16,16,16,16,16,16;
9,16,16,16,16,16,16,16,16,16;
10,16,16,16,16,16,16,16,16,16;
10,16,16,16,16,16,16,16,16,16;
11,16,16,16,16,16,16,16,16,16;
16,16,16,16,16,16,16,16,16,16;
16,16,16,16,16,16,16,16,16,16];

numCeros = 1;
numCerosnt= 0;
bandera = true;

x=1;
y=2;

recto = [1, 0];
diagonal = [-1, 1];

totalCerosnt = 0;

for j = 1:8
    for i = 1:8
        if i == 1 && j == 1
            continue;
        end

        
        if bloqueDivisor(j,i) ~= 0
            totalCerosnt = totalCerosnt + 1;
        end
    end
end

resultado = codigo;
bloque
bloqueCoseno
bloqueDivisor
fprintf("Codi: %d \tCategory: %c/%d \tRes: %s\n", ...
            bloqueDivisor(1, 1), ... % Número codificado
            0, bloqueCategoria(1, 1), ... % Run / Categoría
            bloqueBinario(1, 1)); % Resultado

while(bandera)
    i = y;
    j = x;

    if (bloqueDivisor(j, i) == 0 && numCeros >= 16)
        bloqueBinario(j, i) = "11111111001";
        fprintf("Codi: 0 \tRun/Cat: F/0 \tRes: 11111111001\n");
    elseif(bloqueDivisor(j, i) == 0)
        numCeros = numCeros + 1;
    else

        numCerosnt = numCerosnt + 1;
        categoria = bloqueCategoria(j,i);
        ac = tablaAc(numCeros, categoria);
        binario = dec2bin(abs(bloqueDivisor(j,i)));

        if bloqueDivisor(j, i) < 0
            binario2 = "";
            for k = 1 : strlength(binario)
                binario2 = strcat(binario2, num2str(binario(k) == 0));
            end
            binario2 = dec2bin(bin2dec(binario2) + 1);
            binario = binario2;
        end

        bloqueBinario(j, i) = strcat(ac, binario);
        fprintf("Codi: %d \tRun/Cat: %c/%d \tRes: %s\n", ...
            bloqueDivisor(j, i), ... % Número codificado
            dec2hex(numCeros - 1), bloqueCategoria(j, i), ... % Run / Categoría
            bloqueBinario(j, i)); % Resultado
    end

    resultado = strcat(resultado, bloqueBinario(j, i));

    if (i == 8 && j == 8)
        break;
    end

    j = y + diagonal(1);
    i = x + diagonal(2);

    if(i < 1 || j < 1 || i > 8 || j > 8)
        if(i > 8 && j < 1)
            recto = flip(recto);
        end
        diagonal = flip(diagonal);
        recto = flip(recto);
        y = y + recto(1);
        x = x + recto(2);
    else
        y = j;
        x = i;
    end

    bandera = numCerosnt < totalCerosnt;
end
disp("1010")

resultado = strcat(resultado, "1010")