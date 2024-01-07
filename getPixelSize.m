
function [px, py] = getPixelSize(img, show)

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
    % disp(["Avg y: ",avgY]);
    
    
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
    % disp(["Avg x: ",avgX]);
    
    % Calculate pixel size as solution of system of 2 equations
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

    % disp(["px: ",px]);
    % disp(["py: ",py]);

    if show
        % Display image
        imshow(img);
    end
end

