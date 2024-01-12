clc; clear; close all;

path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));
% a = 1;
% for i = a:a
for i = 1:numel(imageFiles)
    img = imread(fullfile(path, imageFiles(i).name));

    % Calibrate image
    bias = imread(fullfile(strcat(path, '/bias'), 'bias.JPG'));
    dark = imread(fullfile(strcat(path, '/dark'), 'dark.JPG'));
    flat = imread(fullfile(strcat(path, '/flat'), 'flat.JPG'));

    estim_coins(img, bias, dark, flat)

end
