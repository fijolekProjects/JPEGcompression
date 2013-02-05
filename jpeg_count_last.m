% Prosta funkcja uzupelniajaca ostatnia pola w komorkach np z [5, 0] na [0, 50]
% zgodnie z iloscia zer na koncu macierzy
function b = jpeg_count_last (b, AC_decoded)

b{length(b)}(1) = {0};
lastOne = mod(AC_decoded(length(AC_decoded)), 1000);
b{length(b)}(2) = {lastOne};