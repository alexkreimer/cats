function dst = dst2im_ssd(w1,w2)

S = isimilarity(w1,w2,@ssd);
dst = min(S(:));