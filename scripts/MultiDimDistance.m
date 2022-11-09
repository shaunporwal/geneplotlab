function [Distance] = MultiDimDistance(Point1,Point2)
%MultiDimDistance Summary of this function goes here
%   Detailed explanation goes here
Dimensions = length(Point1);
DistanceSquared = 0;
if length(Point1) == length(Point2)
    for i = 1:Dimensions
        DistanceSquared = DistanceSquared + (Point2(i)-Point1(i))^2;
    end
    Distance = DistanceSquared^0.5;
else
    Distance = 0;
end
end

