function [centers, radii, metric] = measureCoins(img,  bias, dark, flat, show)
    % img = calibrate(img, bias, dark, flat, show);
    out = preprocess2(img, show);
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
