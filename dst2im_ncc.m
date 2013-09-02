function dst = dst2im_ncc(w1,w2)

S = isimilarity(w2,w1,@ncc);
dst = max(S(:));