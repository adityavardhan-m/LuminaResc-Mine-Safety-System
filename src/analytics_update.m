function analytics = analytics_update(analytics, t, pwr_step, avg_duty, lux, num_lights)

analytics.energy = analytics.energy + pwr_step * 0.05;

addpoints(analytics.h_eng, t, analytics.energy);
addpoints(analytics.h_pwm, t, avg_duty);
addpoints(analytics.h_lux, t, lux);

end