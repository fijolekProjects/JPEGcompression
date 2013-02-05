 clc;
 clearvars -except quality;

%%                          MZMO PROJEKT
%                          KOMRPESJA JPEG





%% WCZYTANIE ZDJECIA

testImage = imread(uigetfile('*.tif', 'Select a MATLAB code file'));
% figure(1)

% imshow(testImage, 'InitialMagnification', 200);
% title('Obraz oryginalny')
original = testImage;
imwrite(original, 'original.tif');
originalFilesize = dir('original.tif');
originalFilesize = originalFilesize.bytes;
originalFilesizeInKB = num2str(originalFilesize/1024);

testImage = double(testImage) - (128*ones(64));



%% WARTOSC KOMPRESJI
quality;
%% Q50 - TABLICA JAKOSCI ORAZ ORDER - TABLICA ZIGZAG
Q50 = [ 16 11 10 16  24  40   51  61;
    12 12 14 19  26  58   60  55;
    14 13 16 24  40  57   69  56;
    14 17 22 29  51  87   80  62;
    18 22 37 56  68 109  103  77;
    24 35 55 64  81 104  113  92;
    49 64 78 87 103 121  120 101;
    72 92 95 98 112 100  103  99] * quality;

order = [1 9  2  3  10 17 25 18 11 4  5  12 19 26 33  ...
    41 34 27 20 13 6  7  14 21 28 35 42 49 57 50  ...
    43 36 29 22 15 8  16 23 30 37 44 51 58 59 52  ...
    45 38 31 24 32 39 46 53 60 61 54 47 40 48 55  ...
    62 63 56 64];


%% REORDER - ODWROTNOSC ZIGZAGA
reorder = zeros (1, 64);
for i = 1:64
    reorder(order(i)) = i;
end


%% DCT
t = dctmtx(8);
y8x8block = blkproc(testImage, [8 8], 'P1 * x * P2', t, t');


%% PORZADKOWANIE KOLUMN ORAZ ZIGZAG
y8x8block = blkproc(y8x8block, [8 8], 'round(x ./ P1)', Q50);
y64xColumns = im2col(y8x8block, [8 8], 'distinct');
yZigZagColumns = y64xColumns(order, :);


%% KODOWANIE WSPOLCZYNNIKOW DC - KODOWANIE ROZNICOWE ORAZ KODOWANIE HUFFMANA
DC_diff = diff(yZigZagColumns(1,:));
count_DC = arrayfun(@(x) histc(DC_diff, x), unique(DC_diff));

DC_proba = count_DC/63;

DC_symbols = unique(DC_diff);
DC_dict = huffmandict(DC_symbols, DC_proba);
DC_encoded = huffmanenco(DC_diff, DC_dict);
DC_decoded = huffmandeco(DC_encoded, DC_dict);


%% KODWANIE WSPOLCZYNNIKOW AC - KODOWANIE RLE ORAZ KODOWANIE HUFFMANA
for i = 1:64
    rle_cell_temp = jpeg_rle(yZigZagColumns(2:64,i));
    rle_all(i) = {rle_cell_temp};
end

for k = 1:64
    for i = 1:length(rle_all{k}{1})
        AC_BASE = jpeg_showAC(rle_all{k}{1}(i), rle_all{k}{2}(i));
        AC_BASE2{k}(i) = {AC_BASE};
    end
end

for i = 1:64
    count_AC{i} = arrayfun(@(x) histc(cell2mat(AC_BASE2{i}), x), unique(cell2mat(AC_BASE2{i})));
    count_AC{i} = count_AC{i}/length(cell2mat(AC_BASE2{i}));
end

for i = 1:64
    AC_symbols{i} = unique(cell2mat(AC_BASE2{i}));
    AC_dict{i} = huffmandict(AC_symbols{i}, count_AC{i});
    AC_encoded{i} = huffmanenco(cell2mat(AC_BASE2{i}), AC_dict{i});
    AC_decoded{i} = huffmandeco(AC_encoded{i}, AC_dict{i});
end

for i = 1:64
    AC_sorted{i} = arrayfun(@(x)jpeg_showAC_reverse(x), AC_decoded{i}, 'UniformOutput', false);
    AC_sorted{i} = (jpeg_count_last(AC_sorted{i}, AC_decoded{i}));
end


%% przygotowanie danych do wykonania odwrotnego RLE

for k = 1:64
    for i = 1 : length(AC_sorted{k})
        AC_sorted2 = cell2mat(AC_sorted{k}{i}(1));
        AC_sorted3{k}(i) = AC_sorted2;
        AC_sorted4 = cell2mat(AC_sorted{k}{i}(2));
        AC_sorted5{k}(i) = AC_sorted4;
    end
    decodeRleReady{k} = {AC_sorted3{k}, AC_sorted5{k}};
    decodeRleAC{k} = jpeg_rle(decodeRleReady{k});
end


%% odzyskanie macierzy wspolczynnikow DC
DC_reference_value = yZigZagColumns(1, 1);
DC_decoded_values = zeros(1, 64);
DC_decoded_values(1, 1) = DC_reference_value;
for i = 2 : 64
    DC_decoded_values (i) = DC_decoded_values(i-1) + DC_diff(i-1);
end


%% 'sklejenie' wspolczynnikow DC z AC
%
for i = 1:64
    jpeg_decoded_temp{i} = [DC_decoded_values(i); decodeRleAC{i}(:)];
    jpeg_decoded(:, i) = jpeg_decoded_temp{i};
end


%% robie reorder
jpeg_decoded = jpeg_decoded(reorder, :);


%% dziele na bloki 8X8
jpeg_decoded_8x8blocks = im2col(jpeg_decoded, [1 64], [8 8], 'distinct');


%% IDCT
jpeg_decoded_denormalized = blkproc(jpeg_decoded_8x8blocks, [8 8], 'x .* P1', Q50);
jpeg_decoded_IDCT = blkproc(jpeg_decoded_denormalized, [8 8], 'P1 * x * P2', t', t);


%% dodanie 128
FINAL_RESULT = double(jpeg_decoded_IDCT) + (128*ones(64));
FINAL_RESULT = uint8(FINAL_RESULT);

% figure(2)

imwrite(FINAL_RESULT, 'afterJPEG.jpeg');
afterJPEGFilesize = dir('afterJPEG.jpeg');
afterJPEGFilesize = afterJPEGFilesize.bytes;
afterJPEGFilesizeInKB = num2str(afterJPEGFilesize/1024);
% imshow(FINAL_RESULT, 'InitialMagnification', 200);
% title('Obraz po kompresji JPEG')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
