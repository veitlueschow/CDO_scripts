#!bin/bash


# How to get Jochems measure for geostrophy

ug_p="/work/mh0256/m300522/data_storm/geostrophy/2000s/new/ug_p.nc"
vg_p="/work/mh0256/m300522/data_storm/geostrophy/2000s/new/vg_p.nc"

uko_p="/work/mh0256/m300522/data_storm/tape/2000s/uko_p_tm2001-2010.nc"
vke_p="/work/mh0256/m300522/data_storm/tape/2000s/vke_p_tm2001-2010.nc"

divUu="/work/mh0256/m300522/data_storm/eddies/2000s/div_Uu_eddy.nc"
divUv="/work/mh0256/m300522/data_storm/eddies/2000s/div_Uv_eddy.nc"

Ugradu="/work/mh0256/m300522/data_storm/eddies/2000s/U_grad_u.nc"
Ugradv="/work/mh0256/m300522/data_storm/eddies/2000s/U_grad_v.nc"

ftwop="/work/mh0256/m300522/meta_storm/ftwop.nc"

# Now get raw residual (all at p-point)
cdo -sub $uko_p $ug_p uag.nc # equalas ageostrophic part!
cdo -setname,res_v -sub $vke_p $vg_p vag.nc

# Get residual with eddy momentum flux divergence emfd
cdo -setname,res_u_emfd -add uag.nc -div $divUv $ftwop res_u_emfd.nc
cdo -setname,res_v_emfd -sub vag.nc -div $divUu $ftwop res_v_emfd.nc

# Get residual with emfd AND mean momentum advection mma

cdo -setname,res_u_emfd_mma -add res_u_emfd.nc -div $Ugradv $ftwop res_u_emfd_mma.nc
cdo -setname,res_v_emfd_mma -sub res_v_emfd.nc -div $Ugradu $ftwop res_v_emfd_mma.nc

## Now get Jochems measure for each of the versions

## RAW
cdo -setname,jochems_raw -div -sqrt -add -mul uag.nc uag.nc -mul vag.nc vag.nc -sqrt -add -mul $uko_p $uko_p -mul $vke_p $vke_p jochems_raw.nc
cdo -selindexbox,1950,2600,400,1550 -sellevel,1941.5 jochems_raw.nc plot.nc # Choose region to plot

## REMOVE EMFD
#cdo -setname,jochems_emfd -div -sqrt -add -mul res_u_emfd.nc res_u_emfd.nc -mul res_v_emfd.nc res_v_emfd.nc -sqrt -add -mul $uko_p $uko_p -mul $vke_p $vke_p jochems_emfd.nc
#cdo -selindexbox,1950,2600,400,1550 -sellevel,1941.5 jochems_emfd.nc plot_emfd.nc

## REMOVE EMFD and MMA
#cdo -setname,jochems_emfd_mma -div -sqrt -add -mul res_u_emfd_mma.nc res_u_emfd_mma.nc -mul res_v_emfd_mma.nc res_v_emfd_mma.nc -sqrt -add -mul $uko_p $uko_p -mul $vke_p $vke_p jochems_emfd_mma.nc
#cdo -selindexbox,1950,2600,400,1550 -sellevel,1941.5 jochems_emfd_mma.nc plot_emfd_mma.nc

# Get Coriolis * ageostrophic u (at p-point)
cdo -setname,fuag -setgrid,$uko_p -mul $ftwop uag.nc fuag.nc

# Get Coriolis * ageostrophic v (at p-point)
cdo -setname,fvag -setgrid,$vke_p -mul $ftwop vag.nc fvag.nc
