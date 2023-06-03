function sen = getSensitivity(SEG, GT)  
    sen = double(sum(uint8(SEG(:) & GT(:)))) / double(sum(uint8(SEG(:))));  
    fprintf("sensitivity = %f\n", sen);
end  
