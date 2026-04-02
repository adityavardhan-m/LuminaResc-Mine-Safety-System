function [cols, szs, pwr_step, avg_duty, miner_lux] = lighting_controller(lights, miner_pos, is_hazard)

num_lights = size(lights,1);
cols = zeros(num_lights,3);
szs = zeros(num_lights,1);

pwr_step = 0;
sum_duty = 0;
miner_lux = 0;

for i = 1:num_lights
    d = norm(miner_pos - lights(i,:));

    if is_hazard
        if d < 20
            duty = 100; col = [1 0 0];
        else
            duty = 10; col = [0.2 0.2 0.2];
        end
    else
        if d < 15
            duty = 100; col = [1 1 1];
        elseif d < 30
            duty = 25; col = [0.6 0.6 0.4];
        else
            duty = 5; col = [0.1 0.1 0.1];
        end
    end

    cols(i,:) = col;
    szs(i) = 15 + duty/2;

    pwr_step = pwr_step + (24 * duty/100);
    sum_duty = sum_duty + duty;
    miner_lux = miner_lux + (duty / (d^1.5 + 2));
end

avg_duty = sum_duty / num_lights;

end