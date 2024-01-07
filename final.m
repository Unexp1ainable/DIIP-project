clc; clear; close all;

%originalImage = imread('project_images/_DSC1772.JPG');
path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));
a = 1   ;
for i = a:a
% for i = 1:numel(imageFiles)
    img = imread(fullfile(path, imageFiles(i).name));

    % Calibrate image
    bias = imread(fullfile(strcat(path, '/bias'), 'bias.JPG'));
    dark = imread(fullfile(strcat(path, '/dark'), 'dark.JPG'));
    flat = imread(fullfile(strcat(path, '/flat'), 'flat.JPG'));
    % img = calibrate(img, bias, dark, flat, true);   

    % Find circles
    [centers, radii, metric] = measureCoins(img, bias, dark, flat, false);
    [px, py] = getPixelSize(img, false);

    for j = 1:numel(radii)
        % Draw circles
        img = insertShape(img, 'circle', [centers(j, 1), centers(j, 2), radii(j)], 'LineWidth', 2, 'Color', 'green');
        % Draw text
        diameter = radii(j)*2*py;
        coinId = determineCoin(diameter);
        coinStr = coinId2Str(coinId);
        img = insertText(img, [centers(j, 1) - radii(j), centers(j, 2) - radii(j)], coinStr, 'FontSize', 50, 'TextColor', 'black');
        
        disp([])
    end
    
    % Show image
    imshow(img);

end
