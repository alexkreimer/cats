function good_feat = select_good_feat(feat,nfeat,pos_field,neg_field)

% finds best discriminative features
% nfeat number of features to return

N   = length(feat);
th  = nan(1,N);
err = nan(1,N);

Npos = length(feat(1).(pos_field));
Nneg = length(feat(1).(neg_field));
Nsampl = Npos+Nneg;
samples= nan(N,Nsampl);
labels = [1*ones(1,Npos) -1*ones(1,Nneg)];

% weights
D      = ones(Nsampl,1)/Nsampl;

for k = 1:N
    [np,xc_pos] = hist([feat(k).(pos_field).dst]);
    [nn,xc_neg] = hist([feat(k).(neg_field).dst]);
    [th(k),err(k)] = calc_thresh(np,xc_pos,nn,xc_neg);

    for i = 1:Npos
        samples(k,i) = binarize(feat(k).(pos_field)(i).dst,th(k),[1 -1]);
    end
    for j = 1:Nneg
        samples(k,Npos+j) = binarize(feat(k).(neg_field)(j).dst,th(k),[1 -1]);
    end
end

% Choose Features
good_ind = nan(nfeat,1);
for i = 1:nfeat
    % this serves as an indicator function of an error
    errors = abs(repmat(labels,N,1)-samples)/2;
    scores = errors*D;
    [~, good_ind(i)] = min(abs(scores));
    while find(good_ind == good_ind(i),1,'first')<i
        scores(good_ind(i)) = Inf;
        [~, good_ind(i)] = min(abs(scores));
    end
    ind = logical(errors(good_ind(i),:)');
    D(ind) = D(ind)/2;
    D(~ind) = D(~ind)*2;
    D = D./sum(D);
end

% filter out 'bad' features
good_feat = feat(good_ind);

% set appropriate thresholds
for i = 1:nfeat
    good_feat(i).th = th(good_ind(i));
    good_feat(i).er = err(good_ind(i));
end
