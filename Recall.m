% recall
function recall = Recall(SEG, GT)
    recall = double(sum(SEG(:) & GT(:))) / double(sum(GT(:)));
end