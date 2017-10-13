#!/bin/bash
#This script computes the momentum fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields
# u-direction
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
vu0_tm=$idir"vu0_tm"$time".nc"
uu0_tm=$idir"uu0_tm"$time".nc"
wu0_p_tm=$idir"wu0_p_tm"$time".nc"

meta=$idir"wo_tm.nc" # meta file for interpolation on w-points

# eddy u momentum flux u at u-point
if [ -f "uu_eddy.nc" ]
then
  echo "uu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$uko_tm -setname,uu_eddy -sub $uu0_tm -mul $uko_tm $uko_tm uu_eddy.nc 
fi

# eddy u momentum flux v at v-point
if [ -f "vu_eddy.nc" ]
then
  echo "vu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setgrid,$vke_tm -setname,vu_eddy -sub $vu0_tm -mul -setgrid,$vke_tm -mulc,0.25 -add -add $uko_tm -shiftx,+1,cyclic $uko_tm -add -shifty,-1,cyclic $uko_tm -shiftx,+1,cyclic $uko_tm $vke_tm vu_eddy.nc
fi


# eddy u momentum flux w at p-point
if [ -f "wu_eddy.nc" ]
then
  echo "wu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,wu_eddy -sub $wu0_p_tm -mul -setgrid,$wo_p_tm $wo_p_tm -mulc,0.5 -add -shiftx,+1,cyclic $uko_tm $uko_tm wu_eddy.nc 
fi

# Get partial derivates in x,y z direction

# dx (at p-point)
if [ -f "dx_uu_eddy.nc" ]
then
  echo "dx_uu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_uu_eddy -div -setgrid,$dlxp -sub uu_eddy.nc -shiftx,+1,cyclic uu_eddy.nc $dlxp dx_uu_eddy.nc
fi

# dy (at p-point)
if [ -f "dy_vu_eddy.nc" ]
then
  echo "dy_vu_eddy.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vu_eddy -div -setgrid,$dlyp -sub -shifty,+1,cyclic vu_eddy.nc vu_eddy.nc $dlyp dy_vu_eddy.nc
fi



# dz (at p-point)
if [ -f "dz_wu_eddy.nc" ]
then
  echo "dz_wu_eddy.nc exists"
else
# First interpolate wv on w-points:
  pfile="wu_eddy.nc"
  wfile="wu_eddy_w.nc"
  lvl=$(cdo showlevel $meta | tr " " ",")
  lvls=${lvl:1:400}
  cdo intlevelx,$lvls $pfile $wfile

# Then compute the vertical derivative from that
  ofile="dz_wu_eddy.nc" # Output on p-point
  oname="wu_eddy" 
# Use tho_tm as metafile for p-points
  cdo -setname,$oname -div -sub -sellevidx,1/80 $wfile -sellevidx,2/81 $wfile $ddpo tmp.nc 
  a=$(cdo showlevel tmp.nc)
  b=$(cdo showlevel $tho_tm)
  c=$(echo $a" "$b|tr " " "\n"|sort -g)
  lvls=$(echo $c | tr " " ",")
  cdo chlevel,$lvls tmp.nc $ofile
  rm -f tmp.nc
fi


# add up the three
if [ -f "div_Uu_eddy.nc" ]
then
  echo "div_Uu_eddy.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,div_Uu_eddy -add dz_wu_eddy.nc -add dx_uu_eddy.nc dy_vu_eddy.nc div_Uu_eddy.nc
fi
