function FinalMine_Technical_System
    clc; clear; close all;
    %% --- 1. CONFIGURATION ---
    tunnels = [
        0, 0, 0, 100;      -50, 40, 50, 40;   
        -50, 80, 50, 80;    50, 80, 50, 0;     
        -50, 40, -50, 80;  
    ];
    exits = [0, 0; 50, 0]; 
    
    lights = []; 
    for i = 1:size(tunnels, 1)
        p1 = tunnels(i, 1:2); p2 = tunnels(i, 3:4);
        dist = norm(p2 - p1);
        num_pts = max(2, floor(dist / 6)); 
        xs = linspace(p1(1), p2(1), num_pts);
        ys = linspace(p1(2), p2(2), num_pts);
        lights = [lights; xs', ys'];
    end
    num_lights = size(lights, 1);
    
    % -- STATE VARIABLES --
    miner_pos = [0, 10]; 
    light_override_state = zeros(num_lights, 1); 
    is_drawing_mode = false;
    prev_hazard_state = false;
    response_ms = 0;
    max_gas = 0; 
    max_richter = 0; 
    
    %% --- 2. FIGURE 1: CONTROL PANEL & MAP ---
    fig_ctrl = figure('Name', 'Mine Control & Telemetry', 'Color', [0.1 0.1 0.1], ...
        'Position', [50, 200, 850, 750], 'NumberTitle', 'off', ...
        'WindowButtonDownFcn', @mouse_click_handler, ...
        'WindowKeyPressFcn', @key_press_handler); 
    
    ax_map = axes('Parent', fig_ctrl, 'Position', [0.05, 0.1, 0.60, 0.85], ...
        'Color', 'k', 'XColor', 'w', 'YColor', 'w');
    hold(ax_map, 'on'); axis(ax_map, 'equal');
    xlim(ax_map, [-60, 60]); ylim(ax_map, [-10, 120]);
    
    for i = 1:size(tunnels, 1)
        plot(ax_map, [tunnels(i,1) tunnels(i,3)], [tunnels(i,2) tunnels(i,4)], ...
            'Color', [0.2 0.2 0.2], 'LineWidth', 10);
    end
    
    text(exits(1,1), exits(1,2)-5, 'MAIN ENTRY', 'Color', 'g', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    text(exits(2,1), exits(2,2)-5, 'EMERGENCY EXIT', 'Color', 'y', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    h_lights = scatter(ax_map, lights(:,1), lights(:,2), 60, 'filled');
    h_miner = plot(ax_map, miner_pos(1), miner_pos(2), 'p', ...
            'MarkerSize', 18, 'MarkerFaceColor', 'c', 'Color', 'w');
            
    bg = [0.15 0.15 0.15];
    sld_x = uicontrol('Style', 'slider', 'Min', -50, 'Max', 50, 'Value', 0, 'Position', [620, 650, 200, 20]);
    uicontrol('Style', 'text', 'String', 'Miner X (Arrow Keys)', 'Position', [620, 670, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'w');
    sld_y = uicontrol('Style', 'slider', 'Min', 0, 'Max', 100, 'Value', 10, 'Position', [620, 600, 200, 20]);
    uicontrol('Style', 'text', 'String', 'Miner Y (Arrow Keys)', 'Position', [620, 620, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'w');
    
    sld_gas = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1000, 'Value', 0, 'Position', [620, 520, 200, 20]);
    txt_gas = uicontrol('Style', 'text', 'String', 'Gas: Safe', 'Position', [620, 540, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'g');
    
    sld_seismic = uicontrol('Style', 'slider', 'Min', 0, 'Max', 10, 'Value', 0, 'Position', [620, 460, 200, 20]);
    txt_seismic = uicontrol('Style', 'text', 'String', 'Seismic: Stable', 'Position', [620, 480, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'g');
    
    uicontrol('Style', 'text', 'String', 'LIVE SENSOR DATA', 'Position', [620, 400, 200, 25], 'BackgroundColor', [0.2 0.2 0.3], 'ForegroundColor', 'w', 'FontWeight', 'bold');
    txt_ppm = uicontrol('Style', 'text', 'String', 'PPM: 0', 'Position', [620, 380, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'w');
    txt_richter = uicontrol('Style', 'text', 'String', 'Richter: 0.0', 'Position', [620, 360, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'w');
    txt_latency = uicontrol('Style', 'text', 'String', 'Switch Speed: -- ms', 'Position', [620, 340, 200, 20], 'BackgroundColor', bg, 'ForegroundColor', 'c');
    
    btn_draw = uicontrol('Style', 'togglebutton', 'String', 'ENABLE PATH DRAWING', 'Position', [620, 250, 200, 40], 'Callback', @toggle_draw);
    %% --- 3. FIGURE 2: TECHNICAL ANALYTICS ---
    fig_graphs = figure('Name', 'Technical Analytics', 'Color', 'w', ...
        'Position', [920, 50, 550, 900], 'NumberTitle', 'off');
    
    ax_eng = subplot(4,1,1); 
    h_eng = animatedline('Color', [0 0.6 0], 'LineWidth', 2, 'DisplayName', 'Adaptive System');
    h_trad = animatedline('Color', [0.7 0.7 0.7], 'LineWidth', 1.5, 'LineStyle', '--', 'DisplayName', 'Traditional (All ON)');
    title('Cumulative Energy Consumption'); ylabel('Energy (Joules)'); xlabel('Time Steps'); grid on; legend('Location', 'northwest');
    
    ax_pwm = subplot(4,1,2); h_pwm = animatedline('Color', [0.5 0 0.8], 'LineWidth', 1.5);
    title('Average PWM Duty Cycle'); ylabel('Duty Cycle (%)'); xlabel('Time Steps'); ylim([0 110]); grid on;
    
    ax_freq = subplot(4,1,3); h_freq = animatedline('Color', 'r');
    title('Loop Frequency Accuracy'); ylabel('Frequency (Hz)'); xlabel('Time Steps'); ylim([10 30]); grid on;
    
    ax_lux = subplot(4,1,4); h_lux = animatedline('Color', [0.8 0.5 0], 'LineWidth', 1.5);
    title('Illuminance at Miner Location'); ylabel('Illuminance (Lux)'); xlabel('Time Steps'); grid on;
    %% --- 4. MAIN LOOP ---
    t = 0; total_energy = 0; total_energy_trad = 0;
    
    while ishandle(fig_ctrl) && ishandle(fig_graphs)
        loop_start = tic;
        
        gas_ppm = get(sld_gas, 'Value'); 
        richter = get(sld_seismic, 'Value');
        if gas_ppm > max_gas, max_gas = gas_ppm; end 
        if richter > max_richter, max_richter = richter; end
        
        o2_level = max(0, 20.9 - (gas_ppm / 100)); 
        if gas_ppm < 5
            gas_name = 'Ambient Air'; gas_col = 'g';
        elseif gas_ppm < 35
            gas_name = 'Nitrogen Dioxide (NO2)'; gas_col = 'y';
        elseif gas_ppm < 400
            gas_name = 'Carbon Monoxide (CO)'; gas_col = [1 0.5 0];
        else
            gas_name = 'Hydrogen Sulfide (H2S)'; gas_col = 'r';
        end
        
        if richter < 4.0
            seismic_status = 'Seismic: Stable'; seismic_col = 'g';
            seismic_hazard = false;
        elseif richter <= 5.5
            seismic_status = 'MINOR QUAKE DETECTED'; seismic_col = 'y';
            seismic_hazard = false; 
        else
            seismic_status = 'MAJOR EARTHQUAKE!'; seismic_col = 'r';
            seismic_hazard = true; 
        end
        
        is_hazard = (gas_ppm >= 50 || seismic_hazard || o2_level < 19.5);
        
        set(txt_ppm, 'String', sprintf('%s: %.1f PPM', gas_name, gas_ppm), 'ForegroundColor', gas_col);
        set(txt_richter, 'String', sprintf('Richter: %.1f | O2: %.1f%%', richter, o2_level));
        set(txt_seismic, 'String', seismic_status, 'ForegroundColor', seismic_col);
        
        if is_hazard && ~prev_hazard_state, trigger_timer = tic; end
        
        if gas_ppm >= 50, set(txt_gas, 'String', 'TOXIC GAS!', 'ForegroundColor', 'r');
        else, set(txt_gas, 'String', 'Gas: Safe', 'ForegroundColor', 'g'); end
        
        [fx, fy] = snap_to_route(get(sld_x, 'Value'), get(sld_y, 'Value'), tunnels);
        miner_pos = [fx, fy];
        d1 = norm(miner_pos - exits(1,:)); d2 = norm(miner_pos - exits(2,:));
        target_exit = exits(1 + (d1 > d2), :);
        
        cols = zeros(num_lights, 3); szs = zeros(num_lights, 1);
        pwr_step = 0; sum_duty = 0; miner_lux = 0;
        blink_on = mod(fix(t/2), 2) == 0; 
        
        for i = 1:num_lights
            d_miner = norm(miner_pos - lights(i,:));
            duty = 0; 
            if light_override_state(i) == 1
                col = [0 1 1]; duty = 100;
            elseif is_hazard
                if d_miner < 20 
                     if blink_on, col = [1 0 0]; duty = 100; else, col = [0.1 0 0]; duty = 5; end
                else 
                    d_exit = norm(lights(i,:) - target_exit);
                    if (d_miner + d_exit) < (norm(miner_pos - target_exit) * 1.15)
                        if blink_on, col = [0 1 0]; duty = 100; else, col = [0 0.1 0]; duty = 10; end
                    else, col = [0.05 0.05 0.05]; duty = 2; end
                end
            elseif richter >= 4.0 
                if d_miner < 15, duty = 80; col = [1 1 0]; 
                else, duty = 10; col = [0.2 0.2 0]; end
            else 
                if d_miner < 15, duty = 100; col = [1 1 1];
                elseif d_miner < 30, duty = 25; col = [0.6 0.6 0.4];
                else, duty = 2; col = [0.1 0.1 0.1]; end
            end
            cols(i,:) = col; szs(i) = 15 + duty/2;
            pwr_step = pwr_step + (24 * duty/100); 
            sum_duty = sum_duty + duty;
            miner_lux = miner_lux + (duty / (d_miner^1.5 + 2));
        end
        
        pwr_step_trad = num_lights * 24; 
        set(h_lights, 'CData', cols, 'SizeData', szs);
        set(h_miner, 'XData', miner_pos(1), 'YData', miner_pos(2));
        
        if is_hazard && ~prev_hazard_state
            response_ms = toc(trigger_timer) * 1000;
            set(txt_latency, 'String', sprintf('Switch Speed: %.2f ms', response_ms));
        end
        prev_hazard_state = is_hazard;
        total_energy = total_energy + (pwr_step * 0.05); 
        total_energy_trad = total_energy_trad + (pwr_step_trad * 0.05);
        
        addpoints(h_eng, t, total_energy);
        addpoints(h_trad, t, total_energy_trad); 
        addpoints(h_pwm, t, sum_duty / num_lights);
        addpoints(h_lux, t, miner_lux * 5); 
        addpoints(h_freq, t, 1 / (toc(loop_start) + 0.05));
        
        if t > 50, set([ax_eng, ax_pwm, ax_freq, ax_lux], 'XLim', [t-50, t]); end
        drawnow; t = t + 1; pause(0.05);
    end
    
    %% --- 5. DATA EXTRACTION & COMMAND WINDOW SUMMARY ---
    [t_v, eng_v] = getpoints(h_eng);
    [~, trad_v] = getpoints(h_trad);
    [~, pwm_v] = getpoints(h_pwm);
    [~, lux_v] = getpoints(h_lux);
    
    % Calculation of savings
    final_adaptive = eng_v(end);
    final_traditional = trad_v(end);
    savings_joules = final_traditional - final_adaptive;
    savings_percent = (savings_joules / final_traditional) * 100;

    % DISPLAY TO COMMAND WINDOW
    fprintf('\n==================================================\n');
    fprintf('          MINE SYSTEM TECHNICAL SUMMARY           \n');
    fprintf('==================================================\n');
    fprintf('Total Steps Processed:   %.0f\n', t);
    fprintf('Traditional Consumption: %.2f Joules\n', final_traditional);
    fprintf('Adaptive Consumption:    %.2f Joules\n', final_adaptive);
    fprintf('--------------------------------------------------\n');
    fprintf('TOTAL ENERGY SAVED:      %.2f Joules\n', savings_joules);
    fprintf('PERCENTAGE SAVINGS:      %.2f %%\n', savings_percent);
    fprintf('--------------------------------------------------\n');
    fprintf('Peak Gas Level:          %.1f PPM\n', max_gas);
    fprintf('Peak Seismic Activity:   %.1f Richter\n', max_richter);
    fprintf('Last Response Latency:   %.2f ms\n', response_ms);
    fprintf('==================================================\n\n');

    % Summary Plot Figure
    fig_summary = figure('Name', 'Final System Results', 'Color', 'w', 'Position', [400, 300, 800, 500]);
    subplot(2,1,1);
    plot(t_v, trad_v, 'r--', 'LineWidth', 1.5); hold on;
    plot(t_v, eng_v, 'g', 'LineWidth', 2);
    title('Total Energy Consumption Comparison'); ylabel('Total Joules'); xlabel('Time Steps');
    legend('Traditional System', 'Adaptive System', 'Location', 'northwest'); grid on;
    
    subplot(2,2,3); plot(t_v, pwm_v, 'm', 'LineWidth', 1.5); 
    title('Average PWM Cycle'); ylabel('Duty Cycle (%)'); xlabel('Time Steps'); grid on;
    
    subplot(2,2,4); plot(t_v, lux_v, 'k', 'LineWidth', 1.5); 
    title('Illuminance Over Time'); ylabel('Lux at Miner'); xlabel('Time Steps'); grid on;
    
    fig_projection = figure('Name', 'Hardware & Reliability Projection', 'Color', 'w', 'Position', [450, 150, 800, 600]);
    subplot(2,2,1);
    bat_capacity = 50000;
    plot(t_v, max(0, bat_capacity - trad_v), 'r--', 'LineWidth', 1.5); hold on;
    plot(t_v, max(0, bat_capacity - eng_v), 'g', 'LineWidth', 2);
    title('Battery Life Projection'); ylabel('Remaining Energy (J)'); xlabel('Time Steps'); grid on;
    
    subplot(2,2,2);
    wear_trad = cumsum(ones(size(t_v)));
    wear_adapt = cumsum(pwm_v / 100);
    plot(t_v, 100 - (wear_trad/max(wear_trad)*20), 'r--', 'LineWidth', 1.5); hold on;
    plot(t_v, 100 - (wear_adapt/max(wear_trad)*20), 'b', 'LineWidth', 2);
    title('Estimated LED Component Life'); ylabel('Life Expectancy (%)'); xlabel('Time Steps'); grid on;
    legend('Traditional', 'Adaptive');
    
    subplot(2,1,2);
    scatter(eng_v, lux_v, 10, t_v, 'filled'); colorbar;
    xlabel('Energy Consumed (Joules)'); ylabel('Safety Index (Lux at Miner)');
    title('Safety Index vs. Energy Trade-off'); grid on;
    
    %% --- HELPERS ---
    function key_press_handler(~, event) 
        step = 2; 
        switch event.Key
            case 'leftarrow', set(sld_x, 'Value', max(get(sld_x,'Min'), get(sld_x,'Value') - step));
            case 'rightarrow', set(sld_x, 'Value', min(get(sld_x,'Max'), get(sld_x,'Value') + step));
            case 'uparrow', set(sld_y, 'Value', min(get(sld_y,'Max'), get(sld_y,'Value') + step));
            case 'downarrow', set(sld_y, 'Value', max(get(sld_y,'Min'), get(sld_y,'Value') - step));
        end
    end
    function toggle_draw(src, ~)
        is_drawing_mode = get(src, 'Value');
        if is_drawing_mode, set(src, 'String', 'DRAWING ACTIVE', 'BackgroundColor', 'g');
        else, set(src, 'String', 'ENABLE PATH DRAWING', 'BackgroundColor', [0.3 0.3 0.3]); end
    end
    function mouse_click_handler(~, ~)
        if ~is_drawing_mode, return; end
        pt = get(ax_map, 'CurrentPoint');
        dists = sqrt((lights(:,1)-pt(1,1)).^2 + (lights(:,2)-pt(1,2)).^2);
        [min_d, idx] = min(dists);
        if min_d < 8, light_override_state(idx) = ~light_override_state(idx); end
    end
    function [fx, fy] = snap_to_route(rx, ry, segs)
        best_d = inf; fx = rx; fy = ry;
        for k=1:size(segs,1)
            x1=segs(k,1); y1=segs(k,2); x2=segs(k,3); y2=segs(k,4);
            L2 = (x2-x1)^2 + (y2-y1)^2;
            if L2==0, t_prj=0; else, t_prj=((rx-x1)*(x2-x1)+(ry-y1)*(y2-y1))/L2; end
            t_prj = max(0, min(1, t_prj));
            px = x1 + t_prj*(x2-x1); py = y1 + t_prj*(y2-y1);
            d = (rx-px)^2 + (ry-py)^2;
            if d < best_d, best_d=d; fx=px; fy=py; end
        end
    end
end