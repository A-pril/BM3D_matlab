img = imread('lena.bmp');
img = im2double(img);

stepPix = 3;          
%考虑到算法复杂度，不用每个像素点都选参照块，通常隔3个像素为一个步长选取，复杂度降到1/9
ReferencePix = 8;         %参照块的大小
ReferencePix2 = 8;         %参照块的大小
ReferenceNum = 16;        %参照块的数目
ReferenceNum2 = 32;        %参照块的数目
NeighbourPix = 39;        %搜索区域的大小
sigma3d = 2.7;            %3d变换阈值系数
hardThreshold = 2500;     %硬阈值 
hardThreshold2 = 400/256;     %最终变换时组合块的阈值
beita = 2;                %kaiser窗的参数

basicImg = OriginalEstimate(img,ReferencePix,ReferenceNum,stepPix,NeighbourPix, ...
   hardThreshold,sigma3d,beita); %获得初步估计的图像
imwrite(basicImg,'lena初步变换.bmp');

basicImg = im2double(imread("lena初步变换.bmp"));
%basicImg = im2double(basicImg);
finalImg = FinalEstimate(basicImg,img,ReferencePix2,ReferenceNum2,stepPix,NeighbourPix, ...
    hardThreshold2,sigma3d,beita);%获得最终图像

imwrite(finalImg,'lena最终变换.bmp');

figure,subplot(1,3,1);imshow(img);title('原图');
subplot(1,3,2);imshow(basicImg);title('初步变换');
subplot(1,3,3);imshow(finalImg);title('最终变换');

