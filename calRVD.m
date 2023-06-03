function RVD = calRVD(SEG, GT)  
    RVD = double(sum(uint8(SEG(:))) ) / double(sum(uint8(GT(:)))) - 1;  
    fprintf("RVD = %f\n", RVD);
end  
