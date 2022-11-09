function [CorrNum,count,sdsto] = ClusCorr(GeneNum, ClusterAssignment,ClusNum, DataMatrix)
    count = 0; 
    sd = zeros(GeneNum,length(DataMatrix(1,:)));
    for j = 1:GeneNum %saving values for cluster assignment 1
        if ClusterAssignment(j) == ClusNum
            count = count + 1; % # of genes in cluster 1
            for k = 1:length(DataMatrix(1,:))
                sd(j,k) = DataMatrix(j,k); %gene profiles in current cluster 
            end
        end
    end
    
    gcc = zeros(length(sd(1,:)),3);
    for i = 1:(length(sd(:,1))-1) % generating CorrCoeffs for all genes in cluster
        if (sd(i,1)~=0)
            for j = (i+1):(length(sd(:,1)))
                if (sd(j,1)~=0)
                     gcc1 = corrcoef(sd(i,:),sd(j,:));
                     gccv = gcc1(2,1);% gene correlation coefficient value
                     gcc(j,i) = gccv;
                end
            end
        end 
    end 
CorrTot = (sum(sum(gcc)));
ac = CorrTot/(nnz(gcc)); %average correlation value, nnz = # of nonzero values in matrix    
CorrNum = num2str(ac);

sdsto = zeros(1,length(sd(1,:)));
for i = 1:length(sd(1,:))
    sdsto(1,i) = sum(sd(:,i))./nnz(sd(:,i));
end
