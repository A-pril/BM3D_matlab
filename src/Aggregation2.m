function [FinalImg,W] = Aggregation2(FinalImg,W,Weight,similar_basics,positions, ...
            CNT,block_size,beta,sigma)
%对3D变换及滤波后输出的stack进行加权累加,得到最终变换的图片

kaiserWindow = kaiser(block_size,beta);
kaiserWindow = kaiserWindow' * kaiserWindow;%二维kaiser窗
Weight = Weight ;%* kaiserWindow

i=1;
j=1;
while i <= CNT
    x = positions(j,1);
    y = positions(j,2);
    if x~=0 && y~=0
        fImg = Weight .* idct2(similar_basics(:,:,i)); %* Kaiser
        FinalImg(x:x+block_size-1,y:y+block_size-1) = FinalImg(x:x+block_size-1,y:y+block_size-1) +fImg;
        W(x:x+block_size-1,y:y+block_size-1) = W(x:x+block_size-1,y:y+block_size-1) + Weight;
        i = i+1;
    end
    j = j+1;
end
end