% Dice_Ratio
function dr = Dice_Ratio(SEG, GT)
    dr = 2*double(sum(uint8(SEG(:) & GT(:)))) / double(sum(uint8(SEG(:))) + sum(uint8(GT(:))));
    fprintf("Dice = %f\n", dr);
end
