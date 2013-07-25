function [th,err_min] = calc_thresh(np,xc_pos,nn,xc_neg)


pos = [xc_pos xc_neg];
th = nan;
err_min = Inf;
for i = 1:length(pos)
    ind1 = find(xc_pos<=pos(i),1,'last');
    ind2 = find(xc_neg>=pos(i),1,'first');
    e1 = sum(np(ind1:end));
    e2 = sum(nn(1:ind2));
    err = e1 + e2;
    if err < err_min
        err_min = err;
        th = pos(i);
    end
end
