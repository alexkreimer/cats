function feat = calc_dists(params,feat,field)

N = length(params.filenames);
grid_step = params.gridstep;
win_size = params.winsize;

%# for each candidate calculate the distance to each one of the images
for i = 1:N
    idx = i;
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
    
    for k = 1:length(feat)
        feat(k).(field)(i).dst = Inf;
    end
    % go over the grid and choose the patches
    for x = 1:grid_step:size(i1,2)-win_size(2)
        for y = 1:grid_step:size(i1,1)-win_size(1)
            win = i1(y:y+win_size(1)-1,x:x+win_size(2)-1);
            
            % for each patch in the current image evaluate its distance to
            % each one of the features; keep the minimum
            for k = 1:length(feat)
                dst = norm(norm(feat(k).data(:)-win(:)));
                if dst < feat(k).(field)(i).dst
                    feat(k).(field)(i).dst = dst;
                    feat(k).(field)(i).filename = filename;
                    feat(k).(field)(i).mind_loc = [y,x,win_size];
%                     feat(k).(field)(i).min_data = win;
                end
            end
        end
    end
end