function spec = getSpecificity(SEG, GT)  
    [rows, cols] = size(SEG);
    total = rows * cols;
    spec = double(total - (sum(SEG(:)) + sum(GT(:)) - sum(SEG(:) & GT(:)))) / double(total - sum(GT(:)));  
    fprintf("specificity = %f\n", spec);
end
