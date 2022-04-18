function [x,y] = GetBlockStart(i,j,nosImg,block_size)
%............参考块的左上角顶点..............%
    [M,N] = size(nosImg);
    
    if i > 0 && i <= M - block_size
        x = i;
    else if i<=0 
        x = 1;
    else
        x = M - block_size;end
    end

   if j > 0 && j <= N - block_size
        y = j;
    else if j<=0 
        y = 1;
    else
        y = N - block_size;end
   end
end