function dst = dst2im_zncc(w1,w2)

S = isimilarity(w2,w1,@zncc);
dst = min(S(:));