
% getPixelSize calculates the size of a pixel in an image in millimeters.
%
% Inputs:
%   img - The input image.
%   show - A flag indicating whether to display the calculated pixel size and detected checkerboard points.
%
% Outputs:
%   px - The size of a pixel in the x-direction in millimeters.
%   py - The size of a pixel in the y-direction in millimeters.
%
% Example:
%   [px, py] = getPixelSize(img, true);
function [px, py] = getPixelSize(img, show)
warning off vision:calibrate:boardShouldBeAsymmetric;
[imagePoints,boardSize,~] = detectCheckerboardPoints(rgb2gray(img), PartialDetections=false);

boardRows = boardSize(1)-1;
boardCols = boardSize(2)-1;

if show
    % Insert markers at detected point locations
    for j = 1:size(imagePoints,1)
        if isnan(imagePoints(j,1))
            continue;
        end
        img = insertShape(img, 'FilledCircle', [imagePoints(j,1) imagePoints(j,2) 15], 'Color', 'red');
    end
end

% Calculate average distance between points on y axis
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


% Calculate average distance between points on x axis
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

% Calculate pixel size as solution of system of 2 equations arising from the Pythagorean theorem
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


if show
    disp(["Avg x: ",avgX]);
    disp(["px: ",px]);
    disp(["Avg y: ",avgY]);
    disp(["py: ",py]);
    % Display image
    figure; 
    imshow(img);
end
end

