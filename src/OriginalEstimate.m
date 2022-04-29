function [OriImg] = OriginalEstimate(nosImg,block_size,block_num,step,neighbour_size,Threshold,sigma,beita)
%************初步估计***************%

[M,N] = size(nosImg);
OriImg = zeros(M,N);  % 最终返回初步估计的图像
Weight = zeros(M,N);  % 权重

%邻域中，宽、长处理的次数，即两个方向上处理的像素数
widthTimes = floor(N/step);
heightTimes = floor(M/step);

for i = 1:heightTimes+2
    for j =1:widthTimes+2       
        %匹配相似度，排序，得出符合数量block_num的若干块
        %把这些块整合成一个3维的矩阵,此时将二维的块进行DCT变换，
        %similar_blocks = zeros(block_size,block_size,block_num);
        %positions = zeros(block_num,2);
        %CNT = 0;
        %CNT0 = 0;
        x=1+(i-1)*step;
        y=1+(j-1)*step;
        [similar_blocks,positions,CNT] = GetSimilarBlocks(x,y,nosImg,block_size,neighbour_size, ...
            block_num,step,Threshold);

        %在矩阵的第三个维度进行一维变换，通常为阿达马变换haar
        %变换完成后对三维矩阵进行硬阈值处理，将小于阈值的系数置0
        %通过在第三维的一维反变换和二维反变换得到处理后的图像块
        [similar_blocks,CNT0] = CollaborativeFilter(similar_blocks,sigma,Threshold);
        %Aggregation：此时，每个二维块都是对去噪图像的估计。
        % 这一步分别将这些块融合到原来的位置，每个像素的灰度值通过每个对应位置的块的值加权平均，
        % 权重取决于置0的个数和噪声强度。
        [OriImg,Weight] = Aggregation(OriImg,Weight,similar_blocks,positions,CNT0,CNT,block_size,beita,sigma);
    end
end
OriImg(:,:) = OriImg(:,:) ./Weight(:,:);
end

