#!/bin/bash
#This script computes the Eddy kinetic energy EKE
# What is needed?



idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time="2001-2010"

uko_tm=$idir"uko_tm"$time".nc"
vke_tm=$idir"vke_tm"$time".nc"
wo_p_tm=$idir"wo_p_tm"$time".nc"
uv0_tm=$idir"uu0_tm"$time".nc"
vv0_tm=$idir"vv0_tm"$time".nc"
ww0_p_tm=$idir"ww0_p_tm"$time".nc"



# momentum flux u u'u' (at u-point)
if [ -f "uu_eddy.nc" ]
then
  echo "uu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,uu_eddy -sub $uu0_tm -mul $uko_tm $uko_tm uu_eddy.nc 
fi

# eddy momentum flux v v'v' (at v-point)
if [ -f "vv_eddy.nc" ]
then
  echo "vv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,vv_eddy -sub $vv0_tm -mul $vke_tm $vke_tm vv_eddy.nc 
fi

# eddy momentum flux w  w'w' (at p-point)
if [ -f "ww_eddy.nc" ]
then
  echo "ww_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$ww0_p_tm -setname,ww_eddy -sub $ww0_p_tm -mul $wo_p_tm $wo_p_tm ww_eddy.nc 
fi


# add the three to get full EKE (at p-point)
if [ -f "EKE_full.nc" ]
then
  echo "EKE_full.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setgrid,$ww0_p_tm -setname,EKE_full -mulc,0.5 -add ww_eddy.nc -add -add -mulc,0.5 -shiftx,+1,coord,cyclic uu_eddy.nc uu_eddy.nc -add -mulc,0.5 -shifty,+1,coord,cyclic vv_eddy.nc vv_eddy.nc EKE_full.nc
fi

# add only horizontal to get horozontal EKE (like in JS 2012) (at p-point)
if [ -f "EKE_hor.nc" ]
then
  echo "EKE_hor.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setgrid,$ww0_p_tm -setname,EKE_hor -mulc,0.5 -add -add -mulc,0.5 -shiftx,+1,coord,cyclic uu_eddy.nc uu_eddy.nc -add -mulc,0.5 -shifty,+1,coord,cyclic vv_eddy.nc vv_eddy.nc EKE_hor.nc
fi
