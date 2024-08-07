% Plot interannual var. of spatial surface variable over entire region
% 
% Written by J.D. Sharp: 10/18/22
% Last updated by J.D. Sharp: 1/18/23
% 

function plot_temporal_var_full(zmin,zmax,varname,lab,region,lme_shape,lme_idx)

% initialize figure
worldmap([-18 82],[140 302]); box on; hold on;
setm(gca,'MapProjection','robinson','MLabelParallel','south');
set(gcf,'position',[100 100 900 600]);
set(gca,'fontsize',16);
% figure properties
c=colorbar('location','southoutside');
clim([zmin zmax]);
colormap(cmocean('speed'));
c.TickLength = 0;
c.Label.String = lab;
cbarrow;
% plot regions
for n = 1:length(region)
    if any(strcmp(varname,{'DIC' 'fCO2' 'pCO2' 'TA' 'pH' 'OmA' 'OmC' 'H' 'CO3' 'RF' 'ufCO2' 'upCO2' 'TA_DIC'}))
        type = 'OAI_grid';
        vars_grid = load(['Data/' region{n} '/ML_fCO2'],type);
        if strcmp(varname,'H')
            vars_grid.(type).(region{n}).(varname) = ...
                (10^9).*vars_grid.(type).(region{n}).(varname);
        end
    else
        type = 'Preds_grid';
        vars_grid = load(['Data/' region{n} '/gridded_predictors'],type);
    end
    resid = nan(vars_grid.(type).(region{n}).dim.x,vars_grid.(type).(region{n}).dim.y);
    for a = 1:vars_grid.(type).(region{n}).dim.x
        for b = 1:vars_grid.(type).(region{n}).dim.y
            if sum(~isnan(squeeze(vars_grid.(type).(region{n}).(varname)(a,b,:))))>100 % if more than 200 months with observations
            [~,yr,~,~] = leastsq2(vars_grid.(type).(region{n}).month,...
                squeeze(vars_grid.(type).(region{n}).(varname)(a,b,:)),0,2,[6 12]);
            resid(a,b) = std(yr,[],'omitnan');
            else
                resid(a,b) = NaN;
            end
        end
    end
    contourfm(vars_grid.(type).(region{n}).lat,vars_grid.(type).(region{n}).lon,...
        resid',zmin:(zmax-zmin)/200:zmax,'LineStyle','none');
    clear vars_grid resid
end
% plot borders around regions
for n = 1:length(region)
    if n <= 11
        tmp_lon = convert_lon(lme_shape(lme_idx.(region{n})).X');
    else
        tmp_lon = lme_shape(lme_idx.(region{n})).X';
    end
    tmp_lat = lme_shape(lme_idx.(region{n})).Y';
    plotm(tmp_lat,tmp_lon,'k','linewidth',1);
end
% plot land
plot_land('map');
mlabel off
% save figure
if ~isfolder('Figures/full'); mkdir('Figures/full'); end
exportgraphics(gcf,['Figures/full/' varname '_iav.png']);
close
