function feat = calc_dists(params,feat,field)

N = length(params.filenames);

%# for_each image calc its distance to every patch
for i = 1:N
    %read the file
    filename = fullfile(params.dirname,params.filenames(i).name);
    if ~exist(filename,'file')
        continue;
    end
    i1 = imread(filename);
    if size(i1,3) == 3
        i1 = rgb2gray(i1);
    end
    i1 = im2double(i1);
    
    % for each feature compute the distance
    for k = 1:length(feat)
        feat(k).(field)(i).dst = params.dist_fn(i1,feat(k).data);
        feat(k).(field)(i).filename = filename;
    end
    fprintf('%d out of %d\n',i,N);
end