#!/bin/bash

# Computes mean advection term of the momentum equation out of the time-averaged quantities
# Veit August 2017

# v-direction

idir="/work/mh0256/m300522/data_storm/tape/1990s/"
time=""

uko=$idir"uko_tm"$time".nc"
vke=$idir"vke_tm"$time".nc"
wo_p=$idir"wo_p_tm"$time".nc"
rho=$idir"rhopoto_tm"$time".nc"
rho_w=$idir"rhopoto_w_tm"$time".nc"

#uko="uo.nc"
#vke="vo.nc"
#wo_p="wo_p.nc"
#rho="rhopoto.nc"
#rho_w="rhopoto_w.nc"

#vke="/work/mh0256/m300522/data_storm/eddies/60-90/xz/vke_stripe.nc" # At v point
#uko="/work/mh0256/m300522/data_storm/eddies/60-90/xz/uko_stripe.nc" # At u point
#wo_p="/work/mh0256/m300522/data_storm/eddies/60-90/xz/wo_p_stripe.nc" # At p point
#rho="/work/mh0256/m300522/data_storm/eddies/60-90/xz/rhopoto_stripe.nc" # At p point
#rho_w="/work/mh0256/m300522/data_storm/eddies/60-90/xz/rhopoto_w_stripe.nc" # At w point


# Meta files

ddpo="/work/mh0256/m300522/meta_storm/ddpo_dp.nc" # layer thickness
dlxp="/work/mh0256/m300522/meta_storm/dlxp_dp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp_dp.nc"

#ddpo="-selindexbox,1950,2600,1010,1080 /work/mh0256/m300522/meta_storm/ddpo.nc" # layer thickness
#dlxp="-selindexbox,1950,2600,1010,1080 /work/mh0256/m300522/meta_storm/dlxp.nc"
#dlyp="-selindexbox,1950,2600,1010,1080 /work/mh0256/m300522/meta_storm/dlyp.nc"

# Get gradients of velocity fields

#dy
if [ -f "dy_rhopoto.nc" ]
then
  echo "dy_rhopoto.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dy_rhopoto -divc,2. -div -sub -shifty,+1,cyclic $rho -shifty,-1,cyclic $rho $dlyp dy_rhopoto.nc # at p-point
fi

#dx
if [ -f "dx_rhopoto.nc" ]
then
  echo "dx_rhopoto.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dx_rhopoto -divc,2. -div -sub -shiftx,-1,cyclic $rho -shiftx,+1,cyclic $rho $dlxp dx_rhopoto.nc # at p-point
fi

#dz
if [ -f "dz_rhopoto.n	c" ]
then
  echo "dz_rhopoto.nc exists"
else
	cdo -setname,dz_rhopoto -div -sub -sellevidx,1/80 $rho_w -sellevidx,2/81 $rho_w $ddpo tmp.nc # at p-point
	a=$(cdo showlevel tmp.nc)
	b=$(cdo showlevel $rho)
	c=$(echo $a" "$b|tr " " "\n"|sort -g)
	lvls=$(echo $c | tr " " ",")
	cdo chlevel,$lvls tmp.nc dz_rhopoto.nc
	rm -f tmp.nc
fi

# Multiply by velocities

/pf/zmaw/m214003/local/bin/cdo -setname,mean_advection_rho -add -add -mul dz_rhopoto.nc $wo_p -mul dx_rhopoto.nc -mulc,0.5 -add $uko -shiftx,+1,cyclic $uko -mul dy_rhopoto.nc -mulc,0.5 -add $vke -shifty,+1,cyclic $vke U_grad_rho.nc 
