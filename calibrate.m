% calibrate - Function to calibrate an image using bias, dark, and flat fields.
%
% Syntax:
%   out = calibrate(img, bias, dark, flat, show)
%
% Inputs:
%   img   - Input image to be calibrated.
%   bias  - Bias field image.
%   dark  - Dark field image.
%   flat  - Flat field image.
%   show  - Flag to indicate whether to display the calibrated image (optional).
%
% Output:
%   out   - Calibrated image.
function img = calibrate(img, bias, dark, flat, show)
    norm_F = flat - bias - dark;
    norm_F = uint8(double(norm_F)./double(mean(norm_F(:))));

    calibrated_image = (img - bias - dark) ./ norm_F;
    out = calibrated_image;


    if show
        subplot(121); imshow(img); title('Raw Image')
        subplot(122);imshow(out); title('Calibrated Image')
    end
end
