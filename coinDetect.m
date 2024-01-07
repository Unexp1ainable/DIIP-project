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
    
    measureCoins(img, bias, dark, flat, true)
end
