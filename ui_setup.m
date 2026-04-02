function [fig, ax, h_lights, h_miner, ui] = ui_setup(lights, tunnels, exits)

fig = figure('Color',[0.1 0.1 0.1],'Position',[100 100 800 700]);

ax = axes('Parent',fig,'Position',[0.05 0.1 0.6 0.85],'Color','k');
hold(ax,'on'); axis equal;

xlim([-60 60]); ylim([-10 120]);

for i=1:size(tunnels,1)
    plot(ax,[tunnels(i,1) tunnels(i,3)], [tunnels(i,2) tunnels(i,4)], 'LineWidth',10);
end

h_lights = scatter(ax, lights(:,1), lights(:,2), 50, 'filled');
h_miner = plot(ax,0,10,'p','MarkerSize',15,'MarkerFaceColor','c');

ui.sld_x = uicontrol('Style','slider','Min',-50,'Max',50,'Value',0,'Position',[620 600 150 20]);
ui.sld_y = uicontrol('Style','slider','Min',0,'Max',100,'Value',10,'Position',[620 560 150 20]);
ui.sld_gas = uicontrol('Style','slider','Min',0,'Max',1000,'Value',0,'Position',[620 500 150 20]);
ui.sld_seismic = uicontrol('Style','slider','Min',0,'Max',10,'Value',0,'Position',[620 460 150 20]);

ui.txt_ppm = uicontrol('Style','text','String','PPM','Position',[620 420 150 20]);
ui.txt_richter = uicontrol('Style','text','String','Richter','Position',[620 400 150 20]);
ui.txt_seismic = uicontrol('Style','text','String','Seismic','Position',[620 380 150 20]);

end