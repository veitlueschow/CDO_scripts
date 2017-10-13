#!/bin/bash

# Computes mean advection term of the v-momentum equation out of the time-averaged quantities
# Veit august 2017

idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time="2001-2010"

uko=$idir"uko_tm"$time".nc"
vke=$idir"vke_tm"$time".nc"
wo_p=$idir"wo_p_tm"$time".nc"

# Meta files

ddpo="/work/mh0256/m300522/meta_storm/ddpo_dp.nc" # layer thickness
dlxp="/work/mh0256/m300522/meta_storm/dlxp_dp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp_dp.nc"


# Get gradients of velocity fields

#dy at p-point
if [ -f "dy_v.nc" ]
then
  echo "dy_v.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dy_v -div -sub -shifty,+1,cyclic $vke $vke $dlyp dy_v.nc # at p-point
fi

#dx at p-point
if [ -f "dx_v.nc" ]
then
  echo "dx_v.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dx_v -mulc,0.25 -add -add -shifty,+1,cyclic -div -sub -shiftx,-1,cyclic $vke $vke $dlxp -div -sub -shiftx,-1,cyclic $vke $vke $dlxp -add -shifty,+1,cyclic -div -sub $vke -shiftx,+1,cyclic $vke -shiftx,+1,cyclic $dlxp -div -sub $vke -shiftx,+1,cyclic $vke -shiftx,+1,cyclic $dlxp  dx_v.nc # at p-point
fi

#dz - at p-point
if [ -f "dz_v.n	c" ]
then
  echo "dz_v.nc exists"
else

	#interpolation on p-point
	meta="/work/mh0256/m300522/data_storm/tape/2000s/rhopoto_tm2001-2010.nc"
	/pf/zmaw/m214003/local/bin/cdo -setgrid,$meta -mulc,0.5 -add -shifty,+1,cyclic $vke $vke vke_p.nc

	#interpolation on w-point
	meta=$idir"wo_tm"$time".nc"
	lvl=$(cdo showlevel $meta | tr " " ",")
	lvls=${lvl:1:400}
	#echo $lvls
	cdo intlevelx,$lvls vke_p.nc vke_w.nc


	cdo -setname,dz_v -div -sub -sellevidx,1/80 vke_w.nc -sellevidx,2/81 vke_w.nc $ddpo tmp.nc # at p-point
	a=$(cdo showlevel tmp.nc)
	b=$(cdo showlevel vke_p.nc)
	c=$(echo $a" "$b|tr " " "\n"|sort -g)
	lvls=$(echo $c | tr " " ",")
	cdo chlevel,$lvls tmp.nc dz_v.nc
	rm -f tmp.nc
fi

# Multiply by velocities

/pf/zmaw/m214003/local/bin/cdo -setname,momentum_advection_v -add -add -mul dz_v.nc $wo_p -mul dx_v.nc -mulc,0.5 -add $uko -shiftx,+1,cyclic $uko -mul dy_v.nc -mulc,0.5 -add $vke -shifty,+1,cyclic $vke U_grad_v.nc 
