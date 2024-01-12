% measureCoins is a function that measures the centers, radii, and metric of coins in an image.
%
% Inputs:
%   - img: the input image containing the coins
%   - bias: the bias image to correct for uneven illumination
%   - dark: the dark image to correct for dark current noise
%   - flat: the flat image to correct for flat field non-uniformity
%   - show: a flag indicating whether to display the results
%
% Outputs:
%   - centers: the centers of the detected coins
%   - radii: the radii of the detected coins
%   - metric: the metric values indicating the quality of the detected coins
%
% Example usage:
%   img = imread('coins.jpg');
%   bias = imread('bias.jpg');
%   dark = imread('dark.jpg');
%   flat = imread('flat.jpg');
%   show = true;
%   [centers, radii, metric] = measureCoins(img, bias, dark, flat, show);
function [centers, radii, metric] = measureCoins(img,  bias, dark, flat, show)
    img = calibrate(img, bias, dark, flat, show);
    out = preprocess(img, show);
    [centers, radii, metric] = imfindcircles(out, [150 350], 'ObjectPolarity', 'bright', 'Sensitivity', 0.95);

    if show
        figure;
        imshow(out);
        hold on;
        viscircles(centers, radii, 'EdgeColor', 'b');
        title('Circles');
        hold off;
    end
end


% calibrate - Function to calibrate an image using bias, dark, and flat fields.
%
% Syntax:
%   img = calibrate(img, bias, dark, flat, show)
%
% Inputs:
%   img   - Input image to be calibrated.
%   bias  - Bias field image.
%   dark  - Dark field image.
%   flat  - Flat field image.
%   show  - Flag to indicate whether to display the calibrated image (optional).
%
% Output:
%   img   - Calibrated image.
function img = calibrate(img, bias, dark, flat, show)
    master_dark = dark - bias;
    flat = flat - master_dark;

    norm_F = flat;
    norm_F = (double(norm_F)./double(mean(norm_F(:))));

    calibrated_image = double(img - bias - master_dark) ./ norm_F;
    out = calibrated_image;

    if show
        subplot(121); imshow(img); title('Raw Image')
        subplot(122);imshow(out); title('Calibrated Image')
    end
end



% preprocess - Preprocesses an image for coin measurement.
%
%   img: The input image.
%   show: A flag indicating whether to display intermediate results.
%
%   out: The preprocessed image.
%
%   Example:
%   out = preprocess(img, true);
function out = preprocess(img, show)
    grayImage = rgb2gray(img);

    smoothedImage = imgaussfilt(grayImage, 2);

    edgeImage = edge(smoothedImage, 'canny', [0.05 0.2]);

    if show
        figure; imshow(edgeImage);
    end

    % Dilate the image to fill in any gaps
    se = strel('disk', 10);
    dilatedImage = imclose(edgeImage, se);

    out = imfill(dilatedImage, 'holes');
end
