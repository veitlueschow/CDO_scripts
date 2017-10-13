#!/bin/bash
# Computes the gradient of the horizontal velocity field in order to get a vector normal to the mean flow (across-component)

dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
ddpo="/work/mh0256/m300522/meta_storm/ddpo.nc"

vke_p="/work/mh0256/m300522/data_storm/tape/2000s/vke_p_tm2001-2010.nc"
uko_p="/work/mh0256/m300522/data_storm/tape/2000s/uko_p_tm2001-2010.nc"

cdo -add -mul $vke_p $vke_p -mul $uko_p $uko_p vel_hor_mag.nc

# Get partial derivates in x,y direction
# dx (at p-point)
if [ -f "dx_vel_hor_mag.nc" ]
then
  echo "dx_vel_hor_mag.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_vel_hor_mag -div -setgrid,$dlxp -sub vel_hor_mag.nc -shiftx,+1,coord,cyclic vel_hor_mag.nc $dlxp dx_vel_hor_mag.nc
fi

# dy (at p-point)
if [ -f "dy_vel_hor_mag.nc" ]
then
  echo "dy_vel_hor_mag.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vel_hor_mag -div -setgrid,$dlyp -sub vel_hor_mag.nc -shifty,+1,cyclic,coord vel_hor_mag.nc $dlyp dy_vel_hor_mag.nc
fi

cdo -div dx_vel_hor_mag.nc -sqrt -add -mul dx_vel_hor_mag.nc dx_vel_hor_mag.nc -mul dy_vel_hor_mag.nc dy_vel_hor_mag.nc dxN_vel_hor_mag.nc

cdo -div dy_vel_hor_mag.nc -sqrt -add -mul dx_vel_hor_mag.nc dx_vel_hor_mag.nc -mul dy_vel_hor_mag.nc dy_vel_hor_mag.nc dyN_vel_hor_mag.nc
