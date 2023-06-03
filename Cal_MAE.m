% 计算一幅图像的AE
function mae = Cal_MAE(SEG, GT)
    if size(SEG, 1) ~= size(SEG, 1) || size(SEG, 2) ~= size(GT, 2)
        error("seg map and ground truth have different size!\n");
    end
    if ~islogical(GT)
        GT = GT(:,:,1) > 128;
    end
    
    SEG = im2double(SEG(:,:,1));
    fgPixels = SEG(GT);
    % TP + FP
    fprintf("fgPixels len: %d\n", length(fgPixels))
    % TP
    fprintf("fgPixels num: %d\n", sum(fgPixels))
    % 误分割为前景的像素个数（FP）
    fgErrSum = length(fgPixels) - sum(fgPixels);
    % 误分割为背景的像素个数（FN）
    bgErrSum = sum(SEG(~GT));
    % MAE = 误分割的像素数 / 标签像素总数
    mae = (fgErrSum + bgErrSum) / numel(GT);
    fprintf("MAE = %f\n", mae);
end
