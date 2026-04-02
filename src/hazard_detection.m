function [is_hazard, gas_name, gas_col, seismic_status, seismic_col, o2_level] = hazard_detection(gas_ppm, richter)

o2_level = max(0, 20.9 - (gas_ppm / 100));

if gas_ppm < 5
    gas_name = 'Ambient Air'; gas_col = 'g';
elseif gas_ppm < 35
    gas_name = 'NO2'; gas_col = 'y';
elseif gas_ppm < 400
    gas_name = 'CO'; gas_col = [1 0.5 0];
else
    gas_name = 'H2S'; gas_col = 'r';
end

if richter < 4
    seismic_status = 'Stable'; seismic_col = 'g';
    seismic_hazard = false;
elseif richter <= 5.5
    seismic_status = 'Minor Quake'; seismic_col = 'y';
    seismic_hazard = false;
else
    seismic_status = 'MAJOR EARTHQUAKE'; seismic_col = 'r';
    seismic_hazard = true;
end

is_hazard = (gas_ppm >= 50 || seismic_hazard || o2_level < 19.5);

end