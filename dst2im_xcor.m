function min_dst = dst2im_xcor(i1,ft,params)

cc_norm = normxcorr2(ft,i1);

[max_cc_norm, imax] = max( abs(cc_norm(:)) );

min_dst = 1/max(max_cc_norm,eps);

% [ypeak, xpeak] = ind2sub(size(cc_norm), imax(1));
% corr_offset = [ (ypeak-size(template,1)) (xpeak-size(template,2)) ];