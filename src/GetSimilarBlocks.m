function [similarBlocks,similarPosition,Num] = GetSimilarBlocks(x0,y0,nosImg,block_size,neighbour_size, ...
    block_num,step,Threshold)
%*****匹配相似度，排序，得出符合数量block_num的若干块,把这些块整合成一个3维的矩阵*****%
% 第三维坐标放在了第三位！！
% RefercenBlock, 参考块 block_size
% SearchBlcok, 搜索块
% block_size, 参考块的大小
% block_num, 最终分组中一组中块的个数
% step, 步长
%Threshold 阈值，比较相似度

%参考块的左上角顶点
%获取参考块
[x,y] = GetBlockStart(x0,y0,nosImg,block_size);
RefercenBlock = nosImg(x:x+block_size-1,y:y+block_size-1);

%获取邻域窗口
[X,Y] = GetSearchStart(x,y,nosImg,block_size,neighbour_size);
SearchBlcok = nosImg(X:X+neighbour_size-1,Y:Y+neighbour_size-1);

similarBlocks = zeros(block_size,block_size,block_num);%最终返回的特定数量的最相似的块
similarPosition = zeros(block_num,2);

Num = 0;        %最终返回值
similarNum = 1; %临时记录相似块数

[M,N] = size(SearchBlcok);
[m,n] = size(RefercenBlock);
widthNum = floor((M - m)/step);
heightNum = floor((N - n)/step);
similarTemp = zeros(block_size,block_size,widthNum*heightNum);%所有块
positionTemp = zeros(widthNum*heightNum,2);%各个块的位置
distanceTemp = zeros(widthNum*heightNum);%各个块的相似度

RefBlock = dct2(RefercenBlock);
%记录搜索邻域中的每个块及位置和他们与参考块的相似度
nowX = X;
nowY = Y;
for i = 1:heightNum
    for j = 1:widthNum
        %先在二维做离散余弦变换
        NowBlock = dct2(nosImg(nowX:nowX+block_size-1,nowY:nowY+block_size-1));
        distance = sqrt(sum(sum((RefBlock-NowBlock).*(RefBlock-NowBlock)))) / (block_size.^2);%相似度

        if distance < Threshold   % 说明找到了一块符合要求的 %可以不加，加了快一些，但是需要调参？
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
similarNum = similarNum - 1;
if similarNum<=block_num
    similarBlocks = similarTemp;
    similarPosition = positionTemp;
    Num = similarNum;
    
else
    [~,ind]=sort(distanceTemp);%排序
    for i = 1:block_num
        trueIndex = ind(i);
        similarBlocks(:,:,i) = similarTemp(:,:,trueIndex);
        similarPosition(i,:) = positionTemp(trueIndex,:);
        Num = block_num;
    end
end
end