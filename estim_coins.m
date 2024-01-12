% estim_coins - Estimates the number of coins based on the given measurement.
%
%   [coins] = estim_coins(measurement, bias, dark, flat) takes the measurement
%   data along with the bias, dark, and flat images, and returns the estimated
%   number of coins.
%
%   Input arguments:
%   - measurement: The measurement data.
%   - bias: The bias image.
%   - dark: The dark image.
%   - flat: The flat image.
%
%   Output arguments:
%   - coins: The estimated number of coins.
%
%   Example:
%   coins = estim_coins(measurement, bias, dark, flat);
function [coins] = estim_coins(measurement, bias, dark, flat)
    % determine if debug mode is on
    debug = false;
    if (getenv("DEBUG") ~= "")
        debug = true;
    end

    % Find circles
    [centers, radii, metric] = measureCoins(measurement, bias, dark, flat, debug);
    
    % Get pixel size
    [px, py] = getPixelSize(measurement, false);

    % Determine coin type
    coins = [0,0,0,0,0,0];
    for j = 1:numel(radii)
        diameter = radii(j)*2*py;
        coinId = determineCoin(diameter);
        coins(coinId) = coins(coinId) + 1;

        % show measurement with circles and coin type if debug mode is on
        if (debug)
            coinStr = coinId2Str(coinId);
            measurement = insertShape(measurement, 'circle', [centers(j, 1), centers(j, 2), radii(j)], 'LineWidth', 2, 'Color', 'green');
            measurement = insertText(measurement, [centers(j, 1) - radii(j), centers(j, 2) - radii(j)], coinStr, 'FontSize', 50, 'TextColor', 'black');
        end
    end

    % show measurement with circles and coin type if debug mode is on
    if (debug)
        figure;
        imshow(measurement);
    end
end
