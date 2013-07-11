function X = build_feat_vect(good_feat,field)

% good_feat feature struct
% field is a name of a field that should be used (usually 'pos' or 'neg')

% build_feat_vect computes matrix X
% size(X) = (num of images in 'field',num of good features)
%   rows correspond to images, cols to features
% X(j,i) = 1 if the distance of feature i to image j is less than a threshold
% X(j,i) = 0 otherwise

% number of images in the training set
N1 = length([good_feat(1).(field)]);

% number of features
N2 = length(good_feat);

% rows are images; colums are features
X = nan(N1,N2);

% i runs over features
for i = 1:N2
    % k runs over images
    for j = 1:N1
        % binarize the feature vectors
        X(j,i) = binarize(good_feat(i).(field)(j).dst,good_feat(i).th);
    end
end