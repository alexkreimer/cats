function fv = feat_vect(good_feat,i1,params)

% generate feature vector for a given image

N = length(good_feat);
grid_step = params.gridstep;
win_size = params.winsize;

fv = nan(N,1);

for i = 1:N
    v = good_feat(i).data;
    dst = dst2im(i1,v,grid_step,win_size,params.dist_fn);
    fv(i) = binarize(dst,good_feat(i).th);
end
