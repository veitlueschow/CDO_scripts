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

#dx at p-point
if [ -f "dx_u.nc" ]
then
  echo "dx_u.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dx_u -div -sub $uko -shiftx,+1,cyclic $uko $dlxp dx_u.nc # at p-point
fi

#dy at p-point
if [ -f "dy_u.nc" ]
then
  echo "dy_u.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,dy_u -setgrid,$dlxp -mulc,0.25 -add -add -div -sub $uko -shifty,-1,cyclic $uko $dlyp -div -sub -shifty,+1,cyclic $uko $uko -shifty,+1,cyclic $dlyp -add -shiftx,+1,cyclic -div -sub $uko -shifty,-1,cyclic $uko $dlyp -div -sub -shifty,+1,cyclic $uko $uko -shifty,+1,cyclic $dlyp dy_u.nc
fi

#dz - at p-point

if [ -f "dz_u.n	c" ]
then
  echo "dz_u.nc exists"
else
	
	#interpolation on p-point
	meta="/work/mh0256/m300522/data_storm/tape/2000s/rhopoto_tm2001-2010.nc"
	/pf/zmaw/m214003/local/bin/cdo -setgrid,$meta -mulc,0.5 -add -shiftx,+1,cyclic $uko $uko uko_p.nc
	
	#interpolation on w-point
	meta=$idir"wo_tm"$time".nc"
	lvl=$(cdo showlevel $meta | tr " " ",")
	lvls=${lvl:1:400}
	#echo $lvls
	cdo intlevelx,$lvls uko_p.nc uko_w.nc

	cdo -setname,dz_u -div -sub -sellevidx,1/80 uko_w.nc -sellevidx,2/81 uko_w.nc $ddpo tmp.nc # at p-point
	a=$(cdo showlevel tmp.nc)
	b=$(cdo showlevel uko_p.nc)
	c=$(echo $a" "$b|tr " " "\n"|sort -g)
	lvls=$(echo $c | tr " " ",")
	cdo chlevel,$lvls tmp.nc dz_u.nc
	rm -f tmp.nc
fi

# Multiply by velocities

/pf/zmaw/m214003/local/bin/cdo -setname,momentum_advection_u -add -add -mul dz_u.nc $wo_p -mul dx_u.nc -mulc,0.5 -add $uko -shiftx,+1,cyclic $uko -mul dy_u.nc -mulc,0.5 -add $vke -shifty,+1,cyclic $vke U_grad_u.nc 
