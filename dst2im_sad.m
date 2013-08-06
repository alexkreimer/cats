function dst = dst2im_sad(w1,w2)

S = isimilarity(w1,w2,@sad);
dst = min(S(:));