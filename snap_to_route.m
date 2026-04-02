function [fx, fy] = snap_to_route(rx, ry, segs)

best_d = inf;
fx = rx; fy = ry;

for k = 1:size(segs,1)
    x1=segs(k,1); y1=segs(k,2);
    x2=segs(k,3); y2=segs(k,4);

    L2 = (x2-x1)^2 + (y2-y1)^2;
    if L2==0
        t = 0;
    else
        t = ((rx-x1)*(x2-x1)+(ry-y1)*(y2-y1))/L2;
    end

    t = max(0,min(1,t));

    px = x1 + t*(x2-x1);
    py = y1 + t*(y2-y1);

    d = (rx-px)^2 + (ry-py)^2;

    if d < best_d
        best_d = d;
        fx = px; fy = py;
    end
end

end