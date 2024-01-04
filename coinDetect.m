clc; clear; close all;

%originalImage = imread('project_images/_DSC1772.JPG');
path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));

for i = 1:numel(imageFiles)
    img = imread(fullfile(path, imageFiles(i).name));

    out = preprocess2(img);

    figure; imshow(out); title(imageFiles(i).name);

    [centers, radii, metric] = imfindcircles(out, [150 350], 'ObjectPolarity', 'bright', 'Sensitivity', 0.95);

    figure;
    imshow(img);
    hold on;
    viscircles(centers, radii, 'EdgeColor', 'b');
    title(imageFiles(i).name);
    hold off;
end

function out = preprocess1(img)
    grayImage = rgb2gray(img);

    threshold = graythresh(grayImage);

    smoothedImage = imgaussfilt(grayImage, 5);

    binaryImg = imbinarize(smoothedImage, threshold);
    binaryImg = ~binaryImg;

    se = strel('disk', 5);
    cleanedImg = imclose(binaryImg, se);
    out = imfill(cleanedImg, 'holes');
end

function out = preprocess2(img)
    grayImage = rgb2gray(img);

    smoothedImage = imgaussfilt(grayImage, 2); %2

    edgeImage = edge(smoothedImage, 'canny', [0.05 0.2]); %0.05 0.2
    %figure; imshow(edgeImage);

    se = strel('disk', 10);
    dilatedImage = imclose(edgeImage, se);

    out = imfill(dilatedImage, 'holes');
end