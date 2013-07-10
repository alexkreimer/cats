function good_feat = select_good_feat(feat,nfeat,pos_field,neg_field)

% finds best discriminative features
% nfeat number of features to return

N   = length(feat);
th  = nan(1,N);
err = nan(1,N);

for k = 1:N
    [np,xc_pos] = hist([feat(k).(pos_field).dst]);
    [nn,xc_neg] = hist([feat(k).(neg_field).dst]);
    [th(k),err(k)] = calc_thresh(np,xc_pos,nn,xc_neg);
end

% sort so that the error goes up
[~,ind] = sort(err,'ascend');

% gridily choose nfeat best features, but supress non local maxima
good_ind = sup_non_local_maxima(feat,ind,nfeat);

Ng = length(good_ind);

assert(Ng == nfeat);

% filter out 'bad' features
good_feat = feat(good_ind);

% set appropriate thresholds
for i = 1:Ng
    good_feat(i).th = th(good_ind(i));
end


