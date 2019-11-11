function [pcaA V] = fastPCA( A, k )  
% 快速PCA  
% ?入：A --- ?本矩?，每行?一??本  
%      k --- 降?至 k ?  
% ?出：pcaA --- 降?后的 k ??本特征向量?成的矩?，每行一??本，列? k ?降?后的?本特征??  
%      V --- 主成分向量  
[r c] = size(A);  
% ?本均值  
meanVec = mean(A);  
% ?算?方差矩?的?置 covMatT  
Z = (A-repmat(meanVec, r, 1));  
covMatT = Z * Z';  
% ?算 covMatT 的前 k ?本征值和本征向量  
[V D] = eigs(covMatT, k);  
% 得到?方差矩? (covMatT)' 的本征向量  
V = Z' * V;  
% 本征向量?一化??位本征向量  
for i=1:k  
    V(:,i)=V(:,i)/norm(V(:,i));  
end  
% ?性??（投影）降?至 k ?  
pcaA = Z * V;  
% 保存??矩? V 和??原? meanVec  