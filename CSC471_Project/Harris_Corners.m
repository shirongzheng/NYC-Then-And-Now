image1=imread('NYC_New.jpg');
image2=imread('NYC_Old.jpg');
image1=image1(:,:,1);
image2=image2(:,:,1);

[dx, dy]=meshgrid(-1:1, -1:1);
image1_Ix = conv2(double(image1), dx, 'same');
image1_Iy = conv2(double(image1), dy, 'same');

image2_Ix = conv2(double(image2), dx, 'same');
image2_Iy = conv2(double(image2), dy, 'same');

sigma=1;
radius=1;
order=2*radius +1;
threshold=5000;

%implement Gaussian filter
dim=max(1, fix(6*sigma));
m=dim;
n=dim;
[h1, h2] = meshgrid(-(m-1)/2: (m-1)/2, -(n-1)/2: (n-2)/2);
hg=exp(-(h1.^2+h2.^2)/(2*sigma^2));
[a,b]=size(hg);

sum=0;
for i=1:a
    for j=1:b
        sum=sum+hg(i,j);
    end
end

g=hg./sum;

% calculate M matrix
image1_Ix2 = conv2(double(image1_Ix.^2), g, 'same');
image1_Iy2 = conv2(double(image1_Iy.^2), g, 'same');
image1_Ixy = conv2(double(image1_Ix.*image1_Iy), g, 'same');

image2_Ix2 = conv2(double(image2_Ix.^2), g, 'same');
image2_Iy2 = conv2(double(image2_Iy.^2), g, 'same');
image2_Ixy = conv2(double(image2_Ix.*image2_Iy), g, 'same');


% harris measure
R1 = (image1_Ix2.*image1_Iy2 - image1_Ixy.^2) ./ (image1_Ix2+image1_Iy2 +eps);

R2 = (image2_Ix2.*image2_Iy2 - image2_Ixy.^2) ./ (image2_Ix2+image2_Iy2 +eps);

% find local maxima
mx1 = ordfilt2(R1, order^2, ones(order));
mx2 = ordfilt2(R2, order^2, ones(order));
harris_points1 = (R1 == mx1) & (R1 > threshold);
harris_points2 = (R2 == mx2) & (R2 > threshold);
[rows1,cols1]=find(harris_points1);
[rows2,cols2]=find(harris_points2);

rows3=cat(1, rows1, rows2);
[p,q]=size(image1);
cols2=cols2+q;
cols3=cat(1, cols1, cols2);


figure, imshow(cat(2,image1,image2)), hold on,
plot(cols3,rows3,'ys'), title('Harris Corners - New and Old NYC');


point1=[rows1, cols1];
point2=[rows2, cols2];

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);
indexPairs = matchFeatures(features1,features2);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure;
showMatchedFeatures(image1,image2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
title('Corresponding Points found');
