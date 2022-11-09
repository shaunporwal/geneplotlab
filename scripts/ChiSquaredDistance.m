function [Distance] = ChiSquaredDistance(Observed,Expected)
%MultiDimDistance Summary of this function goes here
%   Detailed explanation goes here
Dimensions = length(Observed);
ChiSquared = 0;
if length(Observed) == length(Expected)
    for i = 1:Dimensions
        ChiSquared = ChiSquared + (((Observed(i)-Expected(i))^2)/Expected(i));
    end
    Distance = ChiSquared;
else
    Distance = 0;
end
end