% will pollute your wokspace, sorry about that :)

close all; clearvars; dbstop if error;

% Cegorization:
%   Given an image, decide if there's an object of this category in it
%
%   For example: given an image, decide if there's a car in the image

% ALGO outline (TBImproved):
%   1. Choose a number of images as 'model' images
%   2. For every model image generate a number candidate features.  Here
%   features are square patches of configurable size (mparams.winsize)
%   3. Calc distance from each one of the model features to a positive &
%   negative training images.  Various distance functions may be used.
%   4. for_each(feature) find a threshold that minimizes empirical classification
%   error
%   5. Greedily choose best features, supressing non local maximas
%   6. Build feature matrix X.  X(i,j) corresponds to image i and feature j;
%   X(i,j) = 0 if dist(feat(i),image_j) > thresh_i
%   X(i,j) = 1 othersize
%   7. Train SVM classifier

% folders for positive and negative images respectively
pos_folder = 'positive';
neg_folder = 'negative';

% first, choose a number of images as a 'model' set and generate a set of
% candidate features
if ~exist('model_feat.mat','file')
    fprintf('generating model features...');
    mparams.filenames = [dir(fullfile(pos_folder,'*.png')); dir(fullfile(pos_folder,'*.jpg'))];
    mparams.filenames = mparams.filenames(1:10);
    mparams.dirname = pos_folder;
    mparams.gridstep = 20;
    mparams.winsize = [40 40];
    feat = gen_model_feat(mparams);
    fprintf('done\n');
    save('model_feat.mat','feat','mparams');
else
    fprintf('reading model features from model_feat.mat\n');
    load model_feat
end

if ~exist('pos_feat.mat','file')
    fprintf('generating dists from model to the positive images...');
    pparams.filenames = [dir(fullfile(pos_folder,'*.png')); dir(fullfile(pos_folder,'*.jpg'))];
    pparams.filenames = pparams.filenames(1:20);
    pparams.dirname = pos_folder;
    % for euclidean distance just don't set dist_fn, the distances will be
    % calculated using conv2. gridstep & winsize only relevant for non
    % euclidean distances
    % pparams.dist_fn = @(x,y) norm(x-y);
    % pparams.gridstep = 20;
    % pparams.winsize = [40 40];
    feat = calc_dists(pparams,feat,'pos');
    fprintf('done\n');
    save('pos_feat.mat','feat','pparams');
else
    fprintf('reading pre-computed distances to positive samples from pos_feat.mat\n');
    load pos_feat
end

if ~exist('neg_feat.mat','file')
    fprintf('generating dists from model to the negative images...');
    nparams.filenames = [dir(fullfile(neg_folder,'*.png')); dir(fullfile(neg_folder,'*.jpg'))];
    nparams.filenames = nparams.filenames(1:20);
    nparams.dirname = neg_folder;
    
    % for euclidean distance just don't set dist_fn, the distances will be
    % calculated using conv2. gridstep & winsize only relevant for non
    % euclidean distances
    % nparams.dist_fn = @(x,y) norm(x-y);
    % nparams.gridstep = 20;
    % nparams.winsize = [40 40];
    feat = calc_dists(nparams,feat,'neg');
    fprintf('done\n');
    save('neg_feat.mat','feat','nparams');
else
    fprintf('reading pre-computed distances to negative samples from neg_feat.mat\n');
    load neg_feat
end

good_feat = select_good_feat(feat,10,'pos','neg');
save_features(good_feat);

% build feature vectors
Xp = build_feat_vect(good_feat,'pos');
Xn = build_feat_vect(good_feat,'neg');
Np = size(Xp,1);
Nn = size(Xn,1);

% cross validation, SVM
N  = Np+Nn;

%# number of cross-validation folds:
%# If you have 50 samples, divide them into 10 groups of 5 samples each,
%# then train with 9 groups (45 samples) and test with 1 group (5 samples).
%# This is repeated ten times, with each group used exactly once as a test set.
%# Finally the 10 results from the folds are averaged to produce a single
%# performance estimation.
k        = 10;

% cross validation sets
X       = [Xp; Xn];
y       = [ones(Np,1); zeros(Nn,1)];
indices = crossvalind('Kfold',N,k);
cp  = classperf(y); cp.Label = 'SVM';

err_svm = nan(1,k);

scores_svm = cell(k,1);
test_labels = cell(k,1);

%# CV
for i = 1:k
    %# train/test sets
    test = (indices == i); train = ~test;
    
    %# train an SVM model over training instances
    model = svmtrain(X(train,:), y(train));
    %# test using test instances
    pred = svmclassify(model, X(test,:), 'Showplot',false);
    %# evaluate and update performance object
    cp = classperf(cp, pred, test);
    %# compute confidence score of each classification as its distance to the separating hyperplane
    scores_svm{i} = svmscores(model,X(test,:));
    %# will be used for averaging the ROCs
    test_labels{i} = y(test);
end

%# ROC curve
figure;
grid on;
xlabel('False Positive Rate (FPR)','FontSize',12);
ylabel('True Positive Rate (TPR)','FontSize',12);
title('Classification performance by SVM','FontSize',12);
hold on;
[xx,yy] = perfcurve(test_labels,scores_svm,1,'xvals','all');
plot(xx,yy(:,1),'LineWidth',2); hold on;

%# get accuracy
cp.CorrectRate

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
cp.CountingMatrix

save('svm.mat','model');
save('good_feat.mat','good_feat');