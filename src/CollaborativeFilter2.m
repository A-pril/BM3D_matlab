function [similar_basics,W] = CollaborativeFilter2(similar_basics, similar_blocks,sigma,Threshold)
%*******3D维纳变换的协同滤波******%

[M,N,~] = size(similar_basics);
Weights = zeros(M,N);

for i  = 1:M
    for j = 1:N
        WieY = reshape(similar_basics(i,j,:),[],1);%初步块堆叠而成
        WieY = dct(WieY);
        Norm2 = WieY'*WieY;
        W = (Norm2)/(Norm2 + sigma.^2);
        if W~=0
            Weights(i,j) = 1./(W.^2 * sigma.^2);end
        WieZ = reshape(similar_blocks(i,j,:),[],1);%噪声块堆叠而成
        WieZ = dct(WieZ);
        similar_basics(i,j,:) = idct(W * WieZ);      
    end
end
end