function [OriImg,W] = Aggregation(OriImg,W,similar_blocks,positions,CNT0,CNT, ...
    block_size,beta,sigma)
%***********Aggregation***********%
%这一步分别将这些块融合到原来的位置，每个像素的灰度值通过每个对应位置的块的值加权平均，
% 权重取决于置0的个数和噪声强度。
kaiserWindow = kaiser(block_size,beta);
kaiserWindow = kaiserWindow' * kaiserWindow;%二维kaiser窗

if CNT0 < 1
    CNT0=1;end
weight = 1./(CNT0) * kaiserWindow;

for i = 1:CNT 
    x = positions(i,1);
    y = positions(i,2);
    TemImg = 1./(CNT0) * idct2(similar_blocks(:,:,i)) * kaiserWindow;
    OriImg(x:x+block_size-1,y:y+block_size-1) = OriImg(x:x+block_size-1,y:y+block_size-1) + TemImg;%二维反变换
    W(x:x+block_size-1,y:y+block_size-1)  = W(x:x+block_size-1,y:y+block_size-1) + weight; %??

end
end