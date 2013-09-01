function dst = dst2im_ssd(w1,w2)

S = isimilarity(w2,w1,@ssd);
dst = min(S(:));