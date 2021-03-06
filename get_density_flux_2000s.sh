#!/bin/bash
#This script computes the density fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields

# What is needed?


dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
area="/work/mh0256/m300522/meta_storm/areap.nc"
ddpo="/work/mh0256/m300522/meta_storm/ddpo.nc" # layer thickness


idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time="2001-2010"

uko_tm=$idir"uko_tm"$time".nc"
vke_tm=$idir"vke_tm"$time".nc"
vrpot0_tm=$idir"vrpot0_tm"$time".nc"
urpot0_tm=$idir"urpot0_tm"$time".nc"
wrpot0_p_tm=$idir"wrpot0_p_tm"$time".nc"
rho_tm=$idir"rhopoto_tm"$time".nc"

wo_p_tm=$idir"wo_p_tm"$time".nc"

meta=$idir"wo_tm.nc" # meta file for interpolation on w-points

# eddy density flux u at u-point
if [ -f "urho_eddy.nc" ]
then
  echo "urho_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$uko_tm -setname,urho_eddy -sub $urpot0_tm -mul -setgrid,$uko_tm -mulc,0.5 -add $rho_tm -shiftx,-1,coord,cyclic $rho_tm $uko_tm urho_eddy.nc 
fi

# eddy density flux v at v-point
if [ -f "vrho_eddy.nc" ]
then
  echo "vrho_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$vke_tm -setname,vrho_eddy -sub $vrpot0_tm -mul -setgrid,$vke_tm -mulc,0.5 -add $rho_tm -shifty,-1,coord,cyclic $rho_tm $vke_tm vrho_eddy.nc 
fi

# eddy density flux w at p-point
if [ -f "wrho_eddy.nc" ]
then
  echo "wrho_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$rho_tm -setname,wrho_eddy -sub $wrpot0_p_tm -mul -setgrid,$wo_p_tm $rho_tm $wo_p_tm wrho_eddy.nc 
fi

# Get partial derivates in x,y z direction
# dx (at p-point)
if [ -f "dx_urho_eddy.nc" ]
then
  echo "dx_urho_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_urho_eddy -div -setgrid,$dlxp -sub urho_eddy.nc -shiftx,+1,coord,cyclic urho_eddy.nc $dlxp dx_urho_eddy.nc
fi

# dy (at p-point)
if [ -f "dy_vrho_eddy.nc" ]
then
  echo "dy_vrho_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vrho_eddy -div -setgrid,$dlyp -sub -shifty,+1,coord,cyclic vrho_eddy.nc vrho_eddy.nc $dlyp dy_vrho_eddy.nc
fi

# dz (at p-point)
if [ -f "dz_wrho_eddy.nc" ]
then
  echo "dz_wrho_eddy.nc exists"
else
# First interpolate w+rho+ on W-points:
  pfile="wrho_eddy.nc"
  wfile="wrho_eddy_w.nc"
  lvl=$(cdo showlevel $meta | tr " " ",")
  lvls=${lvl:1:400}
  cdo intlevelx,$lvls $pfile $wfile

# Then compute the vertical derivative from that
  ofile="dz_wrho_eddy.nc" # Output on p-point
  oname="dz_wrho_eddy" 
# Use tho_tm as metafile for p-points
  cdo -setname,$oname -div -sub -sellevidx,1/80 $wfile -sellevidx,2/81 $wfile $ddpo tmp.nc 
  a=$(cdo showlevel tmp.nc)
  b=$(cdo showlevel $rho_tm)
  c=$(echo $a" "$b|tr " " "\n"|sort -g)
  #echo $c
  lvls=$(echo $c | tr " " ",")
  cdo chlevel,$lvls tmp.nc $ofile
  #rm -f tmp.nc
fi



# add the three
if [ -f "div_Urho_eddy.nc" ]
then
  echo "div_Urho_eddy.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setgrid,$rho_tm -setname,div_Urho_eddy -add dz_wrho_eddy.nc -add dx_urho_eddy.nc dy_vrho_eddy.nc div_Urho_eddy.nc
fi
