function [similar_blocks,nzeroCNT] = CollaborativeFilter(similar_blocks,sigma,Threshold)
%三维协同滤波
% 在矩阵的第三个维度进行一维变换，通常为阿达马变换haar
% 变换完成后对三维矩阵进行硬阈值处理，将小于阈值的系数置0
% 通过在第三维的一维反变换和二维反变换得到处理后的图像块
nzeroCNT = 0; %大于阈值的元素个数
[M,N,~] = size(similar_blocks);

Threshold3d = 2.7 * 25  / 256 ;%
for i  = 1:M
    for j = 1:N
        ThirdArray = reshape(similar_blocks(i,j,:),[],1);
        [ThirdArry1,ThirdArry2] = dwt(ThirdArray,'haar');
        ThirdArry1(find(abs(ThirdArry1)<Threshold3d)) = 0;
        ThirdArry2(find(abs(ThirdArry2)<Threshold3d)) = 0;
        nzeroCNT = nzeroCNT +size(find(ThirdArry1~=0),1)+size(find(ThirdArry2~=0),1);
        similar_blocks(i,j,:) = idwt(ThirdArry1,ThirdArry2,'haar');      

        %ThirdArry = reshape(similar_blocks(i,j,:),[],1);
        %ThirdArry = reshape(dct(ThirdArry),[],1);
        %Index = find(abs(ThirdArry)<Threshold3d);
        %ThirdArry(Index) = 0;
        %nzeroCNT = nzeroCNT +size(Index,1);
        %similarBlocks(i,j,:) = idct(ThirdArry);
    end
end
end