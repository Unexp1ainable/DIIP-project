clc; clear; close all;

%originalImage = imread('project_images/_DSC1772.JPG');
path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));

for i = 1:length(imageFiles)
%for i = 6:6
    img = imread(fullfile(path, imageFiles(i).name));
    [px, py] = getPixelSize(img, true);
    disp([px, py]); 
end
