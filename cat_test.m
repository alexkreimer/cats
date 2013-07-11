% will pollute your wokspace, sorry about that :)

close all; clearvars; dbstop if error;

test_im = '';

i1 = im2double(imread(test_im));
if size(i1,3) ~= 1
    i1 = rgb2gray(i1);
end

load svm
load good_feat

params.gridstep = 20;
params.winsize = [40 40];
params.dist_fn = @(x,y) norm(x,y);

fv = feat_vect(good_feat,i1,params);
pred = svmclassify(model, fv, 'Showplot',false);
