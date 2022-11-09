function [InterpolProfile,Xarray] = Interpol(TimePoints,GeneProfile,Resolution)
%Interpol Summary of this function goes here
%   Detailed explanation goes here
Resolution = length(TimePoints) + ((length(TimePoints)-1)*Resolution);
Resolution = TimePoints(1):length(TimePoints)/Resolution:TimePoints(length(TimePoints));
InterpolProfile = spline(TimePoints,GeneProfile,Resolution);
Xarray = Resolution;
end

