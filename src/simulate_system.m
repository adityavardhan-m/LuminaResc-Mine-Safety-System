function simulate_system

%% CONFIG
tunnels = [
    0,0,0,100;
    -50,40,50,40;
    -50,80,50,80;
    50,80,50,0;
    -50,40,-50,80;
];

exits = [0,0; 50,0];
lights = generate_lights(tunnels);
num_lights = size(lights,1);

miner_pos = [0,10];

[fig, ax, h_lights, h_miner, ui] = ui_setup(lights, tunnels, exits);

%% ANALYTICS INIT
analytics = analytics_init();

t = 0;
prev_hazard = false;

while ishandle(fig)

    gas_ppm = get(ui.sld_gas,'Value');
    richter = get(ui.sld_seismic,'Value');

    [is_hazard, gas_name, gas_col, seismic_status, seismic_col, o2] = ...
        hazard_detection(gas_ppm, richter);

    set(ui.txt_ppm,'String',sprintf('%s: %.1f PPM',gas_name,gas_ppm),'ForegroundColor',gas_col);
    set(ui.txt_richter,'String',sprintf('Richter: %.1f | O2: %.1f%%',richter,o2));
    set(ui.txt_seismic,'String',seismic_status,'ForegroundColor',seismic_col);

    [fx, fy] = snap_to_route(get(ui.sld_x,'Value'), get(ui.sld_y,'Value'), tunnels);
    miner_pos = [fx fy];

    [cols, szs, pwr_step, avg_duty, lux] = ...
        lighting_controller(lights, miner_pos, is_hazard);

    set(h_lights,'CData',cols,'SizeData',szs);
    set(h_miner,'XData',miner_pos(1),'YData',miner_pos(2));

    analytics = analytics_update(analytics, t, pwr_step, avg_duty, lux, num_lights);

    drawnow;
    pause(0.05);
    t = t + 1;
end

end