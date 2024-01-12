% coinId2Str - Converts a coin ID to a string representation.
%
%   cs = coinId2Str(coinId) takes a coin ID as input and returns its string representation.
%
%   Input:
%       coinId - The ID of the coin (numeric scalar).
%
%   Output:
%       cs - The string representation of the coin ID.
%
%   Example:
%       coinId = 1;
%       cs = coinId2Str(coinId);
function cs = coinId2Str(coinId)
    strs = ["2€", "1€", "50c", "20c", "10c", "5c"];
    cs = strs(coinId);
end
