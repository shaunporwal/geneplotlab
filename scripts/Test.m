DataMatrix = csvread('Final1.csv');

ClusterNum = 5;
IterNum = 50;
WhichCluster = 5;
 [ClusterAssignment, Iterations, GeneNum, Timepoints] =...
     Kmeans(DataMatrix,ClusterNum,IterNum);
 ClusterAssignment = ClusterAssignment';
 
 for i = 1:(GeneNum)
     for j = 1:Timepoints
        %if ClusterAssignment(i)==WhichCluster
            plot(1:Timepoints, DataMatrix(i,:)); hold on; 
        %end
     end
 end