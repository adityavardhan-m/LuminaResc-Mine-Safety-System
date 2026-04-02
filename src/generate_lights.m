function lights = generate_lights(tunnels)

lights = [];

for i = 1:size(tunnels,1)
    p1 = tunnels(i,1:2);
    p2 = tunnels(i,3:4);

    dist = norm(p2 - p1);
    num_pts = max(2, floor(dist/6));

    xs = linspace(p1(1), p2(1), num_pts);
    ys = linspace(p1(2), p2(2), num_pts);

    lights = [lights; xs', ys'];
end

end