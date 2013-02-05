%% prosta funkcja sklejajaca wartosci dla rle

function [ z ] = jpeg_showAC( a, b )
    if a > 0
        z = 10*a + b;
    end
    if a == 0
        z = b + 1000;
    end;
    if a < 0
        z = 10*a - b;
    end
end

