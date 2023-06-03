% precision
function precision = Precision(SEG, GT)
    precision = double(sum(SEG(:) & GT(:))) / double(sum(SEG(:)));
end



