function [similar_basics,similar_blocks,similarPosition,Num] = GetSimilarBlocks2(x0,y0,nosImg,basicImg,block_size,neighbour_size, ...
            block_num,step,Threshold)
%***************块匹配，返回原图和初步匹配图像的相似块***********%

%参考块的左上角顶点
%获取参考块
[x,y] = GetBlockStart(x0,y0,basicImg,block_size);
RefercenBlock = basicImg(x:x+block_size-1,y:y+block_size-1);
RefBlock = dct2(RefercenBlock);

%获取邻域窗口
[X,Y] = GetSearchStart(x,y,basicImg,block_size,neighbour_size);
SearchBlcok = basicImg(X:X+neighbour_size-1,Y:Y+neighbour_size-1);

similar_blocks = zeros(block_size,block_size,block_num);%最终返回的特定数量的最相似的块,噪音图像
similar_basics = zeros(block_size,block_size,block_num);%最终返回的特定数量的最相似的块，初步变换图像
similarPosition = zeros(block_num,2);

Num = 0;        %最终返回值
similarNum = 1; %临时记录相似块数

[M,N] = size(SearchBlcok);
[m,n] = size(RefercenBlock);
widthNum = floor((M-m)/step);
heightNum = floor((N-n)/step);
similarTemp = zeros(block_size,block_size,widthNum*heightNum);%所有块
positionTemp = zeros(widthNum*heightNum,2);%各个块的位置
distanceTemp = zeros(widthNum*heightNum);%各个块的相似度

%记录搜索邻域中的每个块及位置和他们与参考块的相似度
nowX = X;
nowY = Y;
for i = 1:heightNum
    for j = 1:widthNum
        %先在二维做离散余弦变换
        NowBlock = dct2(basicImg(nowX:nowX+block_size-1,nowY:nowY+block_size-1));
        distance = sqrt(sum(sum((RefBlock-NowBlock).*(RefBlock-NowBlock)))) / (block_size.^2);%相似度

        if distance < Threshold && distance>=0   % 说明找到了一块符合要求的 %可以不加，加了快一些，但是需要调参？
            similarTemp(:,:,similarNum) = NowBlock;
            positionTemp(similarNum,:) = [nowX,nowY];  
            distanceTemp(similarNum) = distance;
            similarNum = similarNum + 1;
        end
        nowY = nowY +step;
    end
    nowX = nowX + step;
    nowY = Y;
end
similarNum = similarNum - 1;%还原


if similarNum<=block_num
    similar_basics = similarTemp;
    similarPosition = positionTemp;
    for i = 1:similarNum
        x = positionTemp(i,1);
        y = positionTemp(i,2);
        similar_blocks(:,:,i) = dct2(nosImg(x:x+block_size-1,y:y+block_size-1));
    end
    Num = similarNum;    
else
    [~,ind]=sort(distanceTemp);%排序

    i=1;
    j=1;
    while i<= block_num
        trueIndex = ind(j);
        x = positionTemp(trueIndex,1);
        y = positionTemp(trueIndex,2);
        if x~=0 && y~=0
            similar_basics(:,:,i) = similarTemp(:,:,trueIndex);
            similarPosition(i,:) = positionTemp(trueIndex,:);
            similar_blocks(:,:,i) = dct2(nosImg(x:x+block_size-1,y:y+block_size-1));
            i = i+1;
        end
        j = j+1;
    end
    Num = block_num;
end
end