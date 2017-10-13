#!/bin/bash
#This script computes the momentum fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields
# v-direction
# What is needed?


dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
area="/work/mh0256/m300522/meta_storm/areap.nc"
ddpo="/work/mh0256/m300522/meta_storm/ddpo.nc" # layer thickness


idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time="2001-2010"

uko_tm=$idir"uko_tm"$time".nc"
vke_tm=$idir"vke_tm"$time".nc"
wo_p_tm=$idir"wo_p_tm"$time".nc"
uv0_tm=$idir"uv0_tm"$time".nc"
vv0_tm=$idir"vv0_tm"$time".nc"
wv0_p_tm=$idir"wv0_p_tm"$time".nc"

meta=$idir"wo_tm.nc" # meta file for interpolation on w-points

# eddy momentum flux u at u-point
if [ -f "uv_eddy.nc" ]
then
  echo "uv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$uko_tm -setname,uv_eddy -sub $uv0_tm -mul -setgrid,$uko_tm -mulc,0.25 -add -add -shifty,+1,cyclic -shiftx,-1,cyclic $vke_tm $vke_tm -add -shiftx,-1,cyclic $vke_tm $vke_tm $uko_tm uv_eddy.nc 
fi

# eddy momentum flux v at v-point
if [ -f "vv_eddy.nc" ]
then
  echo "vv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,vv_eddy -sub $vv0_tm -mul $vke_tm $vke_tm vv_eddy.nc 
fi

# eddy momentum flux w at p-point
if [ -f "wv_eddy.nc" ]
then
  echo "wv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,wv_eddy -sub $wv0_p_tm -mul -setgrid,$wo_p_tm $wo_p_tm -mulc,0.5 -add -shifty,+1,cyclic $vke_tm $vke_tm wv_eddy.nc 
fi

# Get partial derivates in x,y z direction
# dx (at p-point)
if [ -f "dx_uv_eddy.nc" ]
then
  echo "dx_uv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_uv_eddy -div -setgrid,$dlxp -sub uv_eddy.nc -shiftx,+1 uv_eddy.nc $dlxp dx_uv_eddy.nc
fi

# dy (at p-point)
if [ -f "dy_vv_eddy.nc" ]
then
  echo "dy_vv_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vv_eddy -div -setgrid,$dlyp -sub -shifty,+1 vv_eddy.nc vv_eddy.nc $dlyp dy_vv_eddy.nc
fi

# dz (at p-point)
if [ -f "dz_wv_eddy.nc" ]
then
  echo "dz_wv_eddy.nc exists"
else
# First interpolate wv on w-points:
  pfile="wv_eddy.nc"
  wfile="wv_eddy_w.nc"
  lvl=$(cdo showlevel $meta | tr " " ",")
  lvls=${lvl:1:400}
  cdo intlevelx,$lvls $pfile $wfile

# Then compute the vertical derivative from that
  ofile="dz_wv_eddy.nc" # Output on p-point
  oname="wv_eddy" 
# Use tho_tm as metafile for p-points
  cdo -setname,$oname -div -sub -sellevidx,1/80 $wfile -sellevidx,2/81 $wfile $ddpo tmp.nc 
  a=$(cdo showlevel tmp.nc)
  b=$(cdo showlevel $tho_tm)
  c=$(echo $a" "$b|tr " " "\n"|sort -g)
  lvls=$(echo $c | tr " " ",")
  cdo chlevel,$lvls tmp.nc $ofile
  rm -f tmp.nc
fi


# add the three
if [ -f "div_Uv_eddy.nc" ]
then
  echo "div_Uv_eddy.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,div_Uv_eddy -add dz_wv_eddy.nc -add dx_uv_eddy.nc dy_vv_eddy.nc div_Uv_eddy.nc
fi
