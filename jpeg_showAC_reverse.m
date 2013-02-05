%% prosta funkcja pozwalajaca 'rozkleic' rle

function z = jpeg_showAC_reverse( a )

    
   if a > 0 || a < 1000
        x = int8(a/10);
        z{1} = x;
        y = mod(a,10);
        z{2} =  y;
   end
    if a < 0
         x = int8(a/10);
        z{1} = x;
        y = mod(-a, 10);
        z{2} = y;
    end
    
    if a > 1000
        z{1} = 0;
        z{2} = a - 1000;
    end
end

