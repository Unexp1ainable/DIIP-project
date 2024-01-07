clc; clear; close all;

%originalImage = imread('project_images/_DSC1772.JPG');
path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));

for i = 1:numel(imageFiles)
    img = imread(fullfile(path, imageFiles(i).name));

    % Calibrate image
    bias = imread(fullfile(strcat(path, '/bias'), 'bias.JPG'));
    dark = imread(fullfile(strcat(path, '/dark'), 'dark.JPG'));
    flat = imread(fullfile(strcat(path, '/flat'), 'flat.JPG'));
    img = calibrate(img, bias, dark, flat, true);

    out = preprocess2(img, false);

    figure; imshow(out); title(imageFiles(i).name);

    [centers, radii, metric] = imfindcircles(out, [150 350], 'ObjectPolarity', 'bright', 'Sensitivity', 0.95);

    figure;
    imshow(img);
    hold on;
    viscircles(centers, radii, 'EdgeColor', 'b');
    title(imageFiles(i).name);
    hold off;
end

function out = calibrate(img, bias, dark, flat, show)
    norm_F = flat - bias - dark;
    norm_F = uint8(double(norm_F)./double(max(norm_F(:))));

    calibrated_image = (img - bias - dark) ./ norm_F;
    out = calibrated_image;

    if show
        subplot(121); imshow(img); title('Raw Image')
        subplot(122);imshow(calibrated_image); title('Calibrated Image')
    end
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

function out = preprocess2(img, show)
    grayImage = rgb2gray(img);

    smoothedImage = imgaussfilt(grayImage, 2); %2

    edgeImage = edge(smoothedImage, 'canny', [0.05 0.2]); %0.05 0.2

    if show
        figure; imshow(edgeImage);
    end

    se = strel('disk', 10);
    dilatedImage = imclose(edgeImage, se);

    out = imfill(dilatedImage, 'holes');
end