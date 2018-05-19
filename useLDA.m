function LDA_trans = useLDA(PCA_trans, trainFeature, trainLabels, LDA_Dim)
% initialization
projectedImages = trainFeature * PCA_trans; %num*newDim reduce the dimension
[n, dim] = size(projectedImages);
ClassLabel = unique(trainLabels);
nClass = length(ClassLabel);

classCount = NaN(nClass,1);            % group count
GroupMean = NaN(nClass,dim);       % the mean of each value
%centers=zeros(nClass,nClass-1);       % the centers of mean after projection
sb = zeros(dim,dim);          % 类间离散度矩阵
sw = zeros(dim,dim);          % 类内离散度矩阵

% 计算类内离散度矩阵和类间离散度矩阵
totalMean = mean(projectedImages); 
for i = 1 : nClass    
    group = (trainLabels==ClassLabel(i));
    classCount(i) = sum(double(group));
    GroupMean(i,:) = mean(projectedImages(group,:));
    oneSw = zeros(dim,dim);
    for j = 1 : n
        if group(j) == 1
            t = projectedImages(j,:) - GroupMean(i,:);
            oneSw = oneSw + t' * t;
        end
    end
    oneSw = oneSw/classCount(i);
    sw = sw+oneSw;
    
    ssb = GroupMean(i,:) - totalMean;
    sb = sb + ssb'*ssb;
end
sb = sb/nClass;
sw = sw/nClass;

% W 变换矩阵由v的最大的nClass-1个特征值所对应的特征向量构成
v = pinv(sw) * sb;
[evec,eval] = eig(v);
[d, ind] = sort(diag(eval), 'descend');
LDA_trans = evec(:, ind(1:LDA_Dim));
%LDA_trans = fliplr(evec); %the final transfer matrix, newDim*newDim

% % 计算投影后的中心值
% for i=1:nClass
%     group=(p2plabel==ClassLabel(i));
%     centers(i,:)=mean(trainFeature(group,:)*LDAEigenfaces);
% end
