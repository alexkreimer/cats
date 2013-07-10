function save_features(f)

basefile = 'good_feat_%d.png';

for i = 1:length(f)
    imwrite(reshape(f(i).data,40,40),sprintf(basefile,i));
end
