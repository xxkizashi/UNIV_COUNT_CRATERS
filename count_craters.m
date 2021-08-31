clear all;
close all;
clc;

% 画像読み込み
I = imread('original.jpg');
imshow(I)
title('Original Image');

% ノイズ除去
K = wiener2(I,[10 10]);
imshow(K)


% コントラスト調整
J = imadjust(K);
imshow(J)

% エッジ検出
[~,threshold] = edge(J,'canny');
fudgeFactor = 0.8;
BWs = edge(J,'canny',threshold * fudgeFactor);
imshow(BWs)

% 膨張
se90 = strel('line',5,90);
se0 = strel('line',5,0);
BWsdil = imdilate(BWs,[se90 se0]);
imshow(BWsdil)

% 内部塗りつぶし
BWdfill = imfill(BWsdil,'holes');
imshow(BWdfill)

% 収縮
seD = strel('diamond',5);
BWsero = imerode(BWdfill,seD);
BWsero = imerode(BWsero,seD);
imshow(BWsero)

% 小さなオブジェクト削除
BWfinal = bwareaopen(BWsero, 500);

% 可視化
imshow(labeloverlay(I,BWfinal))
title('Mask Over Original Image')

% 数を測定
statsl = regionprops(BWfinal,'Centroid');
Centroid = cat(1, statsl.Centroid);
num = numel(Centroid(:,1))  % クレーターの数

% 画像を保存
FileName = strcat(datestr(datetime('now')),'__',num2str(num),'craters','.png')
saveas(gcf,FileName)