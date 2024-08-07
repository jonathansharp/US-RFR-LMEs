%% plot gifs of surface variables across full region
plot_full_gif(29.75,38.25,cmocean('haline',17),'SSS','Sea Surface Salinity',region,lme_shape,lme_idx)
plot_full_gif(-0.015,0.105,parula(12),'SSH','Sea Surface Height Anomaly (m)',region,lme_shape,lme_idx)
plot_full_gif(1,31,cmocean('thermal',15),'SST',['Sea Surface Temperature (' char(176) 'C)'],region,lme_shape,lme_idx)
plot_full_gif(-0.025,1.025,cmocean('tempo',21),'IceC','Sea Ice Concentration Fraction',region,lme_shape,lme_idx)
plot_full_gif(-0.025,1.025,cmocean('algae',21),'CHL','Sea Surface Chlorophyll (log_{10})',region,lme_shape,lme_idx)
plot_full_gif(-0.5,12.5,cmocean('amp',13),'WindSpeed','Wind Speed (m s^{-1})',region,lme_shape,lme_idx)
plot_full_gif(-2.5,52.5,jet(11),'MLD','Mixed Layer Depth (m)',region,lme_shape,lme_idx)
plot_full_gif(0.990,1.010,cmocean('dense',21),'mslp','Sea Level Pressure (atm)',region,lme_shape,lme_idx)
plot_full_gif(369.5,390.5,cmocean('solar',21),'pCO2_atm','Atmospheric pCO_{2} (\muatm)',region,lme_shape,lme_idx)
