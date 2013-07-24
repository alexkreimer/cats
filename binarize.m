function b = binarize(val,thresh,labels)

if nargin == 2
    labels = [1 0];
end

if val>=thresh
    b = labels(2);
else
    b = labels(1);
end