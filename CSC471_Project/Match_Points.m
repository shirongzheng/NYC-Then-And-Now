%% Read in two images 
imgl = imread('NYC_Old.jpg');
imgr = imread('NYC_New.jpg');

%% corresponding points
load stereoPointPairs
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'NumTrials',2000)

figure;
showMatchedFeatures(imgl,imgr,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');

figure;
showMatchedFeatures(imgl, imgr, matchedPoints1(inliers,:),matchedPoints2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');