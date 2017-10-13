#!/bin/bash
# get thickness diffusivity according to Eden 2007b eq. 21 (raw eddy diffusivity)



dx_rho="../dx_rhopoto.nc" # p-point
dy_rho="../dy_rhopoto.nc" # p-point

Pe2Pm_hor="../Pe2Pm_hor.nc" # energ conversion term according to von Storch 2012 (computed in energy_fluxes.sh)

#----------------------------------------------------- First term demoninator den1
if [ -f "kappa_eden_raw.nc" ]
then
  echo "kappa_eden_raw.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,kappa_eden_raw -mulc,-1. -div $Pe2Pm_hor -add -mul $dx_rho $dx_rho -mul $dy_rho $dy_rho kappa_eden_raw.nc
fi
