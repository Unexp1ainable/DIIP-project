clc; clear; close all;

%originalImage = imread('project_images/_DSC1772.JPG');
path = './data/images';

imageFiles = dir(fullfile(path, '*.JPG'));

for i = 1:length(imageFiles)
%for i = 6:6
    img = imread(fullfile(path, imageFiles(i).name));
    [imagePoints,boardSize,imagesUsed] = detectCheckerboardPoints(img, PartialDetections=false);
    
    boardRows = boardSize(1)-1;
    boardCols = boardSize(2)-1;
    
    % Insert markers at detected point locations
    for j = 1:size(imagePoints,1)
        if isnan(imagePoints(j,1))
            continue;
        end
        img = insertShape(img, 'FilledCircle', [imagePoints(j,1) imagePoints(j,2) 15], 'Color', 'red');
    end
    
    sumY = [0 0];
    num = 0;
    for colIndex = 1:boardCols
        lastPoint = imagePoints((colIndex-1)*boardRows + 1,:);
        
        for rowIndex = 2:boardRows
            index = (colIndex - 1) * boardRows + rowIndex;
            diff = imagePoints(index,:) - lastPoint;
            sumY = sumY + diff;
            num = num+1;
            lastPoint = imagePoints(index,:);
        end
    end
    avgY = sumY / num;
    disp(["Avg y: ",avgY]);
    
    
    sumX = [0 0];
    num = 0;
    for rowIndex = 1:boardRows
        lastPoint = imagePoints(rowIndex,:);
        
        for colIndex = 2:boardCols
            index = (colIndex - 1) * boardRows + rowIndex;
            diff = imagePoints(index,:) - lastPoint;
            sumX = sumX + diff;
            num = num+1;
            lastPoint = imagePoints(index,:);
        end
    end
    avgX = sumX / num;
    disp(["Avg x: ",avgX]);
    

    square_length = 12.5;
    slsq = square_length^2;
    x1 = avgX(1);
    y1 = avgX(2);
    x2 = avgY(1);
    y2 = avgY(2);
    
    x1sq = x1^2;
    x2sq = x2^2;
    y1sq = y1^2;
    y2sq = y2^2;

    d = x1sq/x2sq;

    pysq = slsq*(1-d)/(y1sq-d*y2sq);
    pxsq = (slsq - pysq*y1sq)/x1sq;

    px = sqrt(pxsq);
    py = sqrt(pysq);

    disp(["px: ",px]);
    disp(["py: ",py]);

    
    % Display image
    figure;
    title(imageFiles(i).name)
    imshow(img);
end

function out = preprocess(img)
grayImage = rgb2gray(img);
out = grayImage;
end
