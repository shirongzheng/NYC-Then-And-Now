image1=imread('NYC_New.jpg');
image2=imread('NYC_Old.jpg');
image1=image1(:,:,1);
image2=image2(:,:,1);

point1 = detectHarrisFeatures(image1);
point2 = detectHarrisFeatures(image2);

[features1,valid_points1] = extractFeatures(image1,point1);
[features2,valid_points2] = extractFeatures(image2,point2);

indexPairs = matchFeatures(features1,features2);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure;
showMatchedFeatures(image1,image2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
title('Corresponding Points found');