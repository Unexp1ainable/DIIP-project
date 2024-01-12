% determineCoin - Function to determine the type of coin based on its diameter.
%
% Syntax: coinId = determineCoin(diameter)
%
% Inputs:
%   - diameter: The diameter of the coin in millimeters.
%
% Output:
%   - coinId: The identification of the coin.
%
% Example:
%   coinId = determineCoin(25)
function coinId = determineCoin(diameter)
    e2 = 25.75;
    e1 = 23.25;
    c50 = 24.25;
    c20 = 22.25;
    c10 = 19.75;
    c5 = 21.25;

    diameters = [e2, e1, c50, c20, c10, c5];

    [~, index] = min(abs(diameters - diameter));
    coinId = index;
end
