% Plot all detrended gridded mean fCO2
% define regions
define_regions_eiwg
% load SOCAT grid
load('Data/socat_gridded_2022_no_moorings','SOCAT_grid');
% initialize figure
figure('visible','off'); box on; hold on;
% title('DJF');
worldmap([-18 82],[140 302]);
setm(gca,'MapProjection','robinson','MLabelParallel','south');
set(gcf,'position',[100 100 900 600]);
set(gca,'fontsize',16);
% figure properties
c=colorbar('location','south','Position',[0.45 0.2 0.3 0.025]);
colormap(parula);
caxis([295 475]);
c.FontWeight = 'bold';
c.TickLength = 0;
c.Label.String = 'Surface {\itf}CO_{2} (\muatm)';
cbarrow;
% plot background
% z = mean(SOCAT_grid.fco2_ave_wtd_detrend,3,'omitnan')';
z = mean(cat(3,SOCAT_grid.fco2_ave_wtd_detrend(:,:,6:12:end),...
               SOCAT_grid.fco2_ave_wtd_detrend(:,:,7:12:end),...
               SOCAT_grid.fco2_ave_wtd_detrend(:,:,8:12:end)),...
               3,'omitnan')';
pcolorm(SOCAT_grid.lat,SOCAT_grid.lon,z);
alpha 0.3
% clear SOCAT grid
clear SOCAT_grid
% plot regions
for n = 1:length(region)
    load(['Data/' region{n} '/gridded_pco2'],'SOCAT_grid');
%     z = mean(SOCAT_grid.(region{n}).fco2_ave_wtd_detrend,3,'omitnan')';
    z = mean(cat(3,SOCAT_grid.(region{n}).fco2_ave_wtd_detrend(:,:,6:12:end),...
               SOCAT_grid.(region{n}).fco2_ave_wtd_detrend(:,:,7:12:end),...
               SOCAT_grid.(region{n}).fco2_ave_wtd_detrend(:,:,8:12:end)),...
               3,'omitnan')';
    pcolorm(SOCAT_grid.(region{n}).lat,SOCAT_grid.(region{n}).lon,z);
    clear SOCAT_grid
end
% plot borders around regions
plot_lme_borders(region,lme_shape,lme_idx);
% figure properties
plot_land('map');
mlabel off
% save figure
if ~isfolder('Figures/full'); mkdir('Figures/full'); end
exportgraphics(gcf,'Figures/full/fCO2_obs_JJA.png');
close
% clean up
clear n z h r c tmp_lon
