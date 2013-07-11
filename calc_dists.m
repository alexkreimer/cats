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
        if isfield(params, 'dist_fn')
            feat(k).(field)(i).dst = dst2im(i1,feat(k).data(:),params.gridstep,params.winsize,params.dist_fn);
        else
            feat(k).(field)(i).dst = dst2im_conv(i1,feat(k).data(:));
        end
        feat(k).(field)(i).filename = filename;
    end
end