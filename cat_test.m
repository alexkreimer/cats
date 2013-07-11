% will pollute your wokspace, sorry about that :)

close all; clearvars; dbstop if error;

test_im = 'test10.jpg';

fprintf('reading %s...',test_im);
i1 = im2double(imread(test_im));
if size(i1,3) ~= 1
    i1 = rgb2gray(i1);
end
fprintf('done\n');

imshow(i1,[]);

load svm
load good_feat

params.gridstep = 20;
params.winsize = [40 40];
params.dist_fn = @(x,y) norm(x-y);

fv = feat_vect(good_feat,i1,params);
pred = svmclassify(model, fv', 'Showplot',false);
if pred == 1
    title('there is an object in the image');
else
    title('there is no object in the image');
end