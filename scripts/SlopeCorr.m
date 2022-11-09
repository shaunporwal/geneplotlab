function [Slopes, CorCoff] = SlopeCorr(Cluster)

Slopes = zeros(length(Cluster(:,1)),length(Cluster(1,:)));

for i=1:length(Cluster(:,1))
    
    for j=2:length(Cluster(1,:))
        
        Slopes(i,j) = Cluster(i,j-1)-Cluster(i,j); 
    
    
    end
end


for i=1:length(Cluster(:,1))
    corrcoef(Cluster(i,:));
end







    
end
