clc
clear all
M = csvread('convertcsv3.csv',1,0);
T = [1,2,3,4,5];
Interprofiles = [];
Resolution = 100; % Higher Resolution means the interpolation function will generate more points along the profile and result in a smoother plot, but will increase computation time

for i = 1:length(M(:,1))
    [Interprofile,Xarray] = Interpol(T,M(i,:),Resolution);
    Interprofiles = [Interprofiles;Interprofile];
end

j = 1000;
    plot(Xarray,Interprofiles(j,:),'b--')
    hold on
    plot(T,M(j,:),'ro')
