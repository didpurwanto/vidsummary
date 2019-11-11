function [pcaA V] = fastPCA( A, k )  
% �ֳtPCA  
% ?�J�GA --- ?���x?�A�C��?�@??��  
%      k --- ��?�� k ?  
% ?�X�GpcaA --- ��?�Z�� k ??���S���V�q?�����x?�A�C��@??���A�C? k ?��?�Z��?���S��??  
%      V --- �D�����V�q  
[r c] = size(A);  
% ?������  
meanVec = mean(A);  
% ?��?��t�x?��?�m covMatT  
Z = (A-repmat(meanVec, r, 1));  
covMatT = Z * Z';  
% ?�� covMatT ���e k ?�����ȩM�����V�q  
[V D] = eigs(covMatT, k);  
% �o��?��t�x? (covMatT)' �������V�q  
V = Z' * V;  
% �����V�q?�@��??�쥻���V�q  
for i=1:k  
    V(:,i)=V(:,i)/norm(V(:,i));  
end  
% ?��??�]��v�^��?�� k ?  
pcaA = Z * V;  
% �O�s??�x? V �M??��? meanVec  