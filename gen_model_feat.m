function feat = gen_model_feat(params)

% a number of images are selected as 'model' images
% this function generates a set of candidate features (square patches)
% that are drawn over a coarse grid from this model set
%
% Input Args:
% params.filenames is a vector of (full) filenames that should be used as a
% model set
% params.gridstep a step of a grid
% params.win size in pixels of a feature patch
% Output:
% feat is a structure
% feat(k).data is a patch
% feat(k).filename is a source filename of a patch
%

% size of a model set
N = length(params.filenames);
grid_step = params.gridstep;
win_size = params.winsize;
feat = struct;
k = 1;
%# collect feature candidates from all images over a grid
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

    % go over the grid and choose the patches
    for x = 1:grid_step:size(i1,2)-win_size(2)
        for y = 1:grid_step:size(i1,1)-win_size(1)
            win = i1(y:y+win_size(1)-1,x:x+win_size(2)-1);
            feat(k).data = win;
            feat(k).src  = filename;
            k = k + 1;
        end
    end
end