function [n,xc] = merge_hists(np,xc_pos,nn,xc_neg)

Np = length(np);
Nn = length(nn);

i = 1;
j = 1;
k = 1;

n = nan(Np+Nn,2);
xc= nan(Np+Nn,1);

while 1,
    if i>Np && j>Nn
        break
    end

    if i>Np
        xcp = Inf;
    else
        xcp = xc_pos(i);
    end
    
    if j>Nn
        xcn = Inf;
    else
        xcn = xc_neg(j);
    end

    if xcp < xcn
        xc(k) = xcp;
        n(k,1) = np(i);
        n(k,2) = 0;
        i = i+1;
        k = k+1;
    elseif xcp > xcn
        xc(k) = xcn;
        n(k,1) = 0;
        n(k,2) = nn(j);
        j = j+1;
        k = k+1;
    elseif xcp == xcn
        xc(k) = xcp;
        n(k,1) = np(i);
        n(k,2) = nn(j);
        j = j+1;
        i = i+1;
        k = k+1;
    end
end

n = n(1:k-1,1:2);
xc=xc(1:k-1);

