function save_features(f,label)

basefile = 'good_feat_%s_%d.png';

for i = 1:length(f)
    imwrite(reshape(f(i).data,40,40),sprintf(basefile,label,i));
end
