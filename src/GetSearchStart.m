function [X,Y] = GetSearchStart(x,y,nosImg,block_size,neighbour_size)
%***********得到搜索邻域的左上角顶点**********%
    [M,N] = size(nosImg);
    Xtemp = floor(x + block_size/2 - neighbour_size/2);
    Ytemp = floor(y + block_size/2 - neighbour_size/2);

    if Xtemp > 0 && Xtemp <= M - neighbour_size
        X = Xtemp;
    else if Xtemp<=0 
        X = 1;
    else
        X = M - neighbour_size;end
    end

   if Ytemp > 0 && Ytemp <= N - neighbour_size
        Y = Ytemp;
   else if Ytemp<=0 
        Y = 1;
    else
        Y = N - neighbour_size;end
   end
end