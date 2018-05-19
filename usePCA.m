function PCA_trans = usePCA(trainFeature, newDim)
% Use Principle Component Analysis (PCA) to determine the most 
% discriminating features between images of faces and project to a new
% space
%
% Description: This function gets a 2D matrix, containing all training image vectors
% and returns 3 outputs which are extracted from training database.
%
% Argument:      train                      - A 2D matrix, containing all 1D image vectors.
%                                         Suppose all P images in the training database 
%                                         have the same size of MxN. So the length of 1D 
%                                         column vectors is M*N and 'T' will be a MNxP 2D matrix.
% 
% Returns:       m                      - (M*Nx1) Mean of the training database
%                Eigenfaces             - (M*Nx(P-1)) Eigen vectors of the covariance matrix of the training database
%                A                      - (M*NxP) Matrix of centered image vectors              
 
% Calculating the mean image 

image_mean = mean(trainFeature); % Computing the average face image m = (1/P)*sum(Tj's)    (j = 1 : P)
trainNum = size(trainFeature,1);
A = double(trainFeature) - repmat(image_mean,trainNum,1); 
%Calculating the deviation of each image from mean image num*dim

%%Snapshot method of Eigenface methos
% We know from linear algebra theory that for a PxQ matrix, the maximum
% number of non-zero eigenvalues that the matrix can have is min(P-1,Q-1).
% Since the number of training images (P) is usually less than the number
% of pixels (M*N), the most non-zero eigenvalues that can be found are equal
% to P-1. So we can calculate eigenvalues of A'*A (a PxP matrix) instead of
% A*A' (a M*NxM*N matrix). It is clear that the dimensions of A*A' is much
% larger that A'*A. So the dimensionality will decrease.

L = A*A'; % L is the surrogate of covariance matrix C=A*A'. 294*294
[V, D] = eig(L); % Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.
% Or L = A*A', no L_eig_vec, Eigenfaces is caculated as L_eig_vec shown as follows,
% ProjectedImages = Eigenfaces'*A

%%%%%%%%%%%%%%%%%%%%%%%% Sorting and eliminating eigenvalues
% All eigenvalues of matrix L are sorted and those who are less than a specified 
% threshold, are eliminated. So the number of non-zero eigenvectors may be less than (P-1).
vsort = fliplr(V);
L_eig_vec = vsort(:, 1:newDim);

%%Calculating the eigenvectors of covariance matrix 'C'
% Eigenvectors of covariance matrix C (or so-called "Eigenfaces")
% can be recovered from L's eiegnvectors.
PCA_trans = A' * L_eig_vec; % dim*newDim

