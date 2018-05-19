clear;
close all;
PCA_Dimcyc = 180; %project the image into new dimension
LDA_Dimcyc = PCA_Dimcyc;
PCA_Dimp2p = 190; %project the image into new dimension
LDA_Dimp2p = PCA_Dimp2p;

load('trainok_cycle.mat');
trainFeature = [real; cycle]; %num*dim
trainLabels = [reallabel, cyclelabel];
PCA_trans = usePCA(trainFeature, PCA_Dimcyc); 
LDA_trans = useLDA(PCA_trans, trainFeature, trainLabels, LDA_Dimcyc);
save('transMatrix.mat', 'PCA_trans', 'LDA_trans');
testDataFile = 'testok_cycle.mat';
accuracyCyc = recLDA(PCA_trans, LDA_trans, testDataFile);
% disp(accuracyCyc);
fprintf('%d: Accuracy for cycle  is %f.\n', PCA_Dimcyc, accuracyCyc(1));

load('trainok_p2p.mat');
trainFeature = [real; p2p]; %num*dim
trainLabels = [reallabel, p2plabel];
PCA_trans = usePCA(trainFeature, PCA_Dimp2p); 
LDA_trans = useLDA(PCA_trans, trainFeature, trainLabels, LDA_Dimp2p);
testDataFile = 'testok_p2p.mat';
accuracyP2p = recLDA(PCA_trans, LDA_trans, testDataFile);
disp(accuracyP2p);
fprintf('%d:Accuracy for p2p  is %f.\n', PCA_Dimp2p, accuracyP2p(1));

x = [1:20];
h = plot(x, accuracyCyc, 'ro-', x, accuracyP2p, 'g*-');
set(h,'LineWidth', 1.2);
text(x(1)-0.2,accuracyCyc(1)+0.06,{['rank 1: ' num2str(accuracyCyc(1)) ] ,'\downarrow'},'FontSize',9,'FontWeight','bold');
text(x(1)-0.2,accuracyP2p(1)+0.06,{['rank 1: ' num2str(accuracyP2p(1)) ] ,'\downarrow'},'FontSize',9,'FontWeight','bold');
xlabel('Rank');
ylabel('Accuracy');
axis([0 20 0 1]);
legend({'CycleGAN','Pixel2Pixel'},'Location', 'SouthEast');
