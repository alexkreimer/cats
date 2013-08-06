function dst = dst2im_ncc(w1,w2)

S = isimilarity(w1,w2,@ncc);
dst = max(S(:));