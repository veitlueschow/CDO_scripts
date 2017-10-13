#!/bin/bash

dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
ddpo="/work/mh0256/m300522/meta_storm/ddpo.nc"

idir="/work/mh0256/m300522/data_storm/tape/60-90/"
time="60-90_"

meta=$idir"wo_"$time"tm.nc"
tho_tm=$idir"tho_"$time"tm.nc"

# Get partial derivates in x,y z direction
# dx (at p-point)
if [ -f "dx_u+rho+2o.nc" ]
then
  echo "dx_u+rho+2o.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_urho_eddy -mulc,0.5 -div -setgrid,$dlxp -sub -shiftx,-1 u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp dx_u+rho+2o.nc
fi

# dy (at p-point)
if [ -f "dy_v+rho+2o.nc" ]
then
  echo "dy_v+rho+2o.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vrho_eddy -mulc,0.5 -div -setgrid,$dlyp -sub -shifty,-1 v+rho+.nc -shifty,+1 v+rho+.nc $dlyp dy_v+rho+2o.nc
fi

# dz (at p-point)
if [ -f "dz_w+rho+2o.nc" ]
then
  echo "dz_w+rho+2o.nc exists"
else
# First interpolate w+rho+ on W-points:
  pfile="w+rho+.nc"
  wfile="w+rho+_w.nc"
  lvl=$(cdo showlevel $meta | tr " " ",")
  lvls=${lvl:1:400}
  cdo intlevelx,$lvls $pfile $wfile

# Then compute the vertical derivative from that
  ofile="dz_w+rho+2o.nc" # Output on p-point
  oname="dz_w+rho+" 
# Use tho_tm as metafile for p-points
  cdo -setname,$oname -div -sub -sellevidx,1/79 $wfile -sellevidx,3/81 $wfile -add -sellevidx,1/79 $ddpo -sellevidx,2/80 $ddpo tmp.nc 
  a=$(cdo showlevel tmp.nc)
  b=$(cdo showlevel $tho_tm)
  c=$(echo $a" "$b|tr " " "\n"|sort -g)
  lvls=$(echo $c | tr " " ",")
  cdo chlevel,$lvls tmp.nc $ofile
  #rm -f tmp.nc
fi

# add the three
# /pf/zmaw/m214003/local/bin/cdo -setname,div_Urho_eddy -add -div -setgrid,$dlxp -sub u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp -div -setgrid,$dlyp -sub v+rho+.nc -shifty,+1 v+rho+.nc $dlyp div_U+rho+.nc
/pf/zmaw/m214003/local/bin/cdo -setname,div_Urho_eddy -add dz_w+rho+2o.nc -add dx_u+rho+2o.nc dy_v+rho+2o.nc div_U+rho+2o.nc
