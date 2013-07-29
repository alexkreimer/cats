function min_dst = dst2im_eucledian(i1,ft,params)

grid_step = params.gridstep;
win_size = params.winsize;
dist_fn = @(x,y) norm(x-y);

% compute distance from a feature to an image as a minimum over a grid of
% patches.
min_dst = Inf;
% go over the grid and choose the patches
for x = 1:grid_step:size(i1,2)-win_size(2)
    for y = 1:grid_step:size(i1,1)-win_size(1)
        win = i1(y:y+win_size(1)-1,x:x+win_size(2)-1);
        
        dst = dist_fn(win(:),ft(:));
        if dst < min_dst,
            min_dst = dst;
        end
    end
end
