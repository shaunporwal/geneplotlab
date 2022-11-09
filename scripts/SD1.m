clear
clc
close all;

Data = csvread('convertcsv3.csv',1,0);
SloSto = [];
p = Data(1,:);
for i = 1:length(Data(:,1))
    for j = 2:length(Data(1,:))
        SloSto(i,j-1)=Data(i,j)-Data(i,j-1);
    end
end

for k = 1:length(Data(:,1))
    for l = 1:length(Data(1,:))
        
    end
end



%%
clc; clear all; clc;

Data = csvread('convertcsv3.csv',1,0);
% set1 = Data(1,:);
% set2 = Data(245,:); 

% c = corrcoef(set1, set2); 
% 
% plot(1:5, set1);
% % hold on;
% plot(set2);

[ca1, it, gn, tp] = Kmeans(Data,20,50);



gcc = zeros(length(Data(:,1)));
for i = 1:(length(Data(:,1))-1)
    for j = (i+1):(length(Data(:,1)))
         %if mod(i,2)==0
         gcc1 = corrcoef(Data(i,:),Data(j,:));
         gccv = gcc1(2,1);% gene correlation coefficient value
     	 gcc(j,i) = gccv;
         %end
    end 
end

ds = size(Data); % size of data
ds = ds(1)*ds(2);
ac = (sum(sum(gcc)))/(ds); %average correlation value

% for i = 1 : length(Data(:,1))
%     hold on;
%     plot(1:5,Data(i,:));
% end

%%


DataMatrix = load('Final1.csv');
ClusterNum = 20;
IterNum = 100;
% [ClusterAssignment, Iterations, GeneNum, Timepoints] = ...
%     KmeansChiSquare(DataMatrix,ClusterNum,IterNum)

[ClusterAssignment, Iterations, GeneNum, Timepoints] = ...
    KmeansChiSquare(DataMatrix,ClusterNum,IterNum)

%% testing how to store individual cluster data 

whichclus = 5;

dm = csvread('convertcsv.csv');
[ca,it,gn,tp] = KmeansChiSquare(dm,whichclus,50);
[cn,ct,sd]=ClusCorr(gn,ca,whichclus,tp,dm);

%%
flag = 0; 


h = plot(1:5,1:5);
hold on;

%%





%%

i = plot(1:5,[5,4,3,2,1]);

if flag == 1 
    set(h,'Visible','off')
end
%%

sum(rand(10,10))./10

