function min_dst = dst2im_conv(i1,ft)

C = conv2(i1,ft,'same');
min_dst = 1/min(C(:));