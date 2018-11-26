function out = grayworld(I)
    out = uint8(zeros(size(I,1), size(I,2), size(I,3)));
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    mR = 1/(mean(mean(R)));
    mG = 1/(mean(mean(G)));
    mB = 1/(mean(mean(B)));
    maxRGB = max(max(mR, mG), mB);
    mR = mR/maxRGB;
    mG = mG/maxRGB;
    mB = mB/maxRGB;
    out(:,:,1) = R*mR;
    out(:,:,2) = G*mG;
    out(:,:,3) = B*mB;
end