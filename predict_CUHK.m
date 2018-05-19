clear;
close all;
PCA_Dim = 47; %project the image into new dimension 86  p2p:47
LDA_Dim = PCA_Dim;

load('trainokCUHK_cycle.mat');
trainFeature = [real; cycle]; %num*dim
trainLabels = [reallabel,cyclelabel];
PCA_trans = usePCA(trainFeature, PCA_Dim); 
LDA_trans = useLDA(PCA_trans, trainFeature, trainLabels, LDA_Dim);
% save('transMatrix.mat', 'PCA_trans', 'LDA_trans');
testDataFile = 'testokCUHK_cycle.mat';
accuracyCyc = recLDA(PCA_trans, LDA_trans, testDataFile);
disp(accuracyCyc);
fprintf('Accuracy for cycle  is %f.\n', accuracyCyc(1));

load('trainokCUHK_p2p.mat');
trainFeature = [real; p2p]; %num*dim
trainLabels = [reallabel,p2plabel];
PCA_trans = usePCA(trainFeature, PCA_Dim); 
LDA_trans = useLDA(PCA_trans, trainFeature, trainLabels, LDA_Dim);
% save('transMatrix.mat', 'PCA_trans', 'LDA_trans');
testDataFile = 'testokCUHK_p2p.mat';
accuracyP2p = recLDA(PCA_trans, LDA_trans, testDataFile);
disp(accuracyP2p);
fprintf('Accuracy for p2p  is %f.\n', accuracyP2p(1));

x = [1:20];
h = plot(x, accuracyCyc, 'ro-', x, accuracyP2p, 'g*-');
set(h,'LineWidth', 1.2);
text(x(1)-0.2,accuracyCyc(1)+0.06,{['rank 1: ' num2str(accuracyCyc(1)) ] ,'\downarrow'},'FontSize',9,'FontWeight','bold');
text(x(1)-0.2,accuracyP2p(1)+0.06,{['rank 1: ' num2str(accuracyP2p(1)) ] ,'\downarrow'},'FontSize',9,'FontWeight','bold');
xlabel('Rank');
ylabel('Accuracy');
axis([0 20 0 1]);
legend({'CycleGAN','Pixel2Pixel'},'Location', 'SouthEast');