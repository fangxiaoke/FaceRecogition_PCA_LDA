function accuracy = recLDA(PCA_trans, LDA_trans, testDataFile)

load(testDataFile);
type = strsplit(testDataFile, {'_','.'}); %get p2p or cycle
testFeature = eval(strcat(type{2}, 'Fea'));
testLabel = eval(strcat(type{2}, '_label'));

train_PCA  = testFeature * PCA_trans; %num*newDim
test_PCA = realFea * PCA_trans;
train_LDA  = train_PCA * LDA_trans; %num*newDim
test_LDA = test_PCA * LDA_trans;

testNum = size(test_LDA,1);
trainNum = size(train_LDA,1);
dist = zeros(testNum,trainNum);

for i = 1 : testNum
    for j = 1 : trainNum
        %dist(i,j) = ( norm( test_LDA(i,:) - train_LDA(j,:) ) )^2;
        dist(i,j) = pdist2(test_LDA(i,:), train_LDA(j,:), 'cosine');
    end 
end

accuracy = zeros(1,20);
for r = 1 : 20
    right = 0;
    for i = 1 : testNum
        [~, index] = sort(dist(i,:));
        detect = testLabel(index(1:r));
        if ismember(real_label(i),detect)
            right = right + 1;
%         else 
%             if r == 1
%                 fprintf('%d, ', real_label(i));
%             end
        end
    end
    accuracy(r) = right/testNum;
end
