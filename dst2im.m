function dst = dst2im(i1,ft,grid_step,win_size,dist_fn)

% compute distance from a feature to an image as a minimum over a grid of
% patches.

% go over the grid and choose the patches
for x = 1:grid_step:size(i1,2)-win_size(2)
    for y = 1:grid_step:size(i1,1)-win_size(1)
        win = i1(y:y+win_size(1)-1,x:x+win_size(2)-1);
        
        dst = dist_fn(win(:),ft);
        if dst < min_dst,
            min_dst = dst;
        end
    end
end
