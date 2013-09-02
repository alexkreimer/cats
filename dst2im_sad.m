function dst = dst2im_sad(w1,w2)

S = isimilarity(w2,w1,@sad);
dst = min(S(:));