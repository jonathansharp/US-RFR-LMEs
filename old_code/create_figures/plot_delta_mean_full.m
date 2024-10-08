% Plot temporal mean of spatial surface variable over entire region
% 
% Written by J.D. Sharp: 10/18/22
% Last updated by J.D. Sharp: 1/31/23
% 

function plot_delta_mean_full(zmin,zmax,cmap_type,cmap_name,...
    zero_piv,num_groups,varname,lab,region,lme_shape,lme_idx,test_idx)

% initialize figure
figure('visible','on'); hold on;
worldmap([-18 82],[140 302]);
setm(gca,'MapProjection','robinson','MLabelParallel','south');
set(gcf,'position',[100 100 900 600]);
set(gca,'fontsize',16);
% figure properties
c=colorbar('location','south','Position',[0.45 0.2 0.3 0.025]);
caxis([zmin zmax]);
if strcmp(cmap_type,'cmocean')
    if zero_piv == 1
        colormap(cmocean(cmap_name,'pivot',0));
    else
        colormap(cmocean(cmap_name));
    end
elseif strcmp(cmap_type,'stnd')
    colormap(cmap_name);
end
c.FontWeight = 'bold';
c.FontSize = 10;
c.TickLength = 0;
c.Label.String = lab;
cbarrow;
%mlabel off
% plot regions
type = 'Val';
for n = 1:length(region)
for en = 1:size(num_groups,2)
    if test_idx == 0
        vars_grid_temp = ...
            load(['Data/' region{n} '/us_lme_model_evals'],type);
    elseif test_idx == 1
        vars_grid_temp = ...
            load(['Data/' region{n} '/us_lme_model_evals_test'],type);
    end
    vars_grid.([type num2str(en)]).(region{n}) = ...
        vars_grid_temp.(type).(region{n});
    clear vars_grid_temp
end
vars_grid.(type).(region{n}).(varname) = ...
    mean(cat(4,vars_grid.Val1.(region{n}).(varname)),4);
z = mean(vars_grid.(type).(region{n}).(varname),3,'omitnan')';
lat = vars_grid.([type num2str(en)]).(region{n}).lat;
lon = vars_grid.([type num2str(en)]).(region{n}).lon;
pcolorm(lat,lon,z)
end
% plot borders around regions
plot_lme_borders(region,lme_shape,lme_idx);
% plot land
plot_land('map');
% save figure
if ~isfolder('Figures/full'); mkdir('Figures/full'); end
exportgraphics(gcf,['Figures/full/' varname '.png']);
close