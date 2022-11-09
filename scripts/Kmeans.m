function [ClusterAssignment, Iterations, GeneNum, Timepoints, AntiCorrValue, AntiClusterAssignment] = ...
    Kmeans(DataMatrix,ClusterNum,IterNum)
Iterations = 0; 
MaxExpression = (max(DataMatrix));
GeneNum = length(DataMatrix(:,1));% # of genes
Timepoints = length(DataMatrix(1,:));
Centroids = abs(MaxExpression.*rand(ClusterNum,Timepoints));
ClusterAssignment = zeros(1,GeneNum);
AntiClusterAssignment = zeros(1,length(Centroids(:,1)));

% to Summarize: 
% In =

% Data Matrix, Max # of Desired Clusters, # of Rows of plots, # of
% cols of plots, max # of iterations, 

% Out = 

% Cluster assignments of genes 

% So, In = DataMatrix, ClusterNum, Rows, Cols, MaxIterations
%     Out = ClusterAssignments


for i = 1:IterNum
    for j = 1:GeneNum
       Distances = [];
       for k = 1:ClusterNum
           Distances = [Distances MultiDimDistance(DataMatrix(j,:),Centroids(k,:))];
       end
       sort(Distances);
       [DistanceToCluster, ClusterAssignment(j)] = min(Distances);
    end
    
    OldCentroids = Centroids;
    
    for j = 1:ClusterNum
        Total = zeros(1,Timepoints);
        n = 0;
        for k = 1:GeneNum
            if ClusterAssignment(k) == j
                Total = Total + DataMatrix(k,:);
                n = n + 1;
            end
        end
        if n ~= 0
            Centroids(j,:) = Total ./ n;
        end
    end
    if Centroids == OldCentroids
        Iterations = i;
        break
    end
end

for l = 1:length(Centroids(:,1))
    CorrScores = zeros(1,length(Centroids(:,1)));
    for m = 1:length(Centroids(:,1))
        Correlate = corrcoef(Centroids(l,:),Centroids(m,:));
        CorrScores(m) = Correlate(2,1);
    end
    [AntiCorrValue,AntiClusterAssignment(l)] = min(CorrScores);
end

end


