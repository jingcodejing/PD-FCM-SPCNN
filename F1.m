
% F1 score
function f1 = F1(SEG, GT)
    precision = Precision(SEG, GT);
    recall = Recall(SEG, GT);
    f1 = double(precision * recall * 2) / double(precision + recall);
end