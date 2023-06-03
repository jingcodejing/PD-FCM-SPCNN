function VOE = calVOE(SEG, GT)  
    VOE = 2*double(sum(uint8(SEG(:))) - sum(uint8(GT(:)))) / double(sum(uint8(SEG(:))) + sum(uint8(GT(:))));  
    fprintf("VOE = %f\n", VOE);
end  
