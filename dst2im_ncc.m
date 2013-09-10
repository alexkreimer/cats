function dst = dst2im_ncc(image,tmpl)

% S = isimilarity(w2,w1,@ncc);
% dst = max(S(:));

cc = normxcorr2(tmpl,image);
[max_cc,~] = max(abs(cc(:)));
dst = 1/max_cc;