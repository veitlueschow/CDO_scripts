#!/bin/bash
#This script computes the density fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields

# What is needed?


beta="/work/mh0256/m300522/meta_storm/beta.nc"
alpha="/work/mh0256/m300522/meta_storm/alpha.nc"
dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
area="/work/mh0256/m300522/meta_storm/areap.nc"
ddpo="/work/mh0256/m300522/meta_storm/ddpo.nc" # layer thickness


idir="/work/mh0256/m300522/data_storm/tape/1990s/"
#idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time=""
#time=""

tho_tm=$idir"tho_"$time"tm.nc"
sao_tm=$idir"sao_"$time"tm.nc"
uko_tm=$idir"uko_"$time"tm.nc"
vke_tm=$idir"vke_"$time"tm.nc"
vs0_tm=$idir"vs0_"$time"tm.nc"
vt0_tm=$idir"vt0_"$time"tm.nc"
us0_tm=$idir"us0_"$time"tm.nc"
ut0_tm=$idir"ut0_"$time"tm.nc"

#tho_tm="thetao.nc"
#sao_tm="so.nc"
#uko_tm="uo.nc"
#vke_tm="vo.nc"
#vs0_tm="vs0.nc"
#vt0_tm="vt0.nc"
#us0_tm="us0.nc"
#ut0_tm="ut0.nc"
wo_tm=$idir"wo_p_"$time"tm.nc"
ws0_tm=$idir"ws0_p_"$time"tm.nc"
wt0_tm=$idir"wt0_p_"$time"tm.nc"

meta=$idir"wo_"$time"tm.nc" # meta file for interpolation on w-points
#meta="wo.nc" 

# eddy temp flux u
if [ -f "u+t+.nc" ]
then
  echo "u+t+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,ut_eddy -sub $ut0_tm -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $tho_tm $tho_tm $uko_tm u+t+.nc 
fi

# eddy salt flux u
if [ -f "u+s+.nc" ]
then
  echo "u+s+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,us_eddy -sub $us0_tm -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $sao_tm $sao_tm $uko_tm u+s+.nc 
fi

# eddy temp flux v
if [ -f "v+t+.nc" ]
then
  echo "v+t+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,vt_eddy -sub $vt0_tm -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $tho_tm $tho_tm $vke_tm v+t+.nc
fi

# eddy salt flux v
if [ -f "v+s+.nc" ]
then
  echo "v+s+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,vs_eddy -sub $vs0_tm -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $sao_tm $sao_tm $vke_tm v+s+.nc
fi

# eddy temp flux w
if [ -f "w+t+.nc" ]
then
  echo "w+t+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,wt_eddy -sub $wt0_tm -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $tho_tm $tho_tm $wo_tm w+t+.nc
fi

# eddy salt flux w
if [ -f "w+s+.nc" ]
then
  echo "w+s+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,ws_eddy -sub $ws0_tm -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $sao_tm $sao_tm $wo_tm w+s+.nc
fi

# eddy density flux u (definded at u-point)
if [ -f "u+rho+.nc" ]
then
  echo "u+rho+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,urho_eddy -add -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $alpha $alpha u+t+.nc -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $beta $beta u+s+.nc u+rho+.nc
fi

# eddy density flux v (defined at v-point)
if [ -f "v+rho+.nc" ]
then
  echo "v+rho+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,vrho_eddy -add -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $alpha $alpha v+t+.nc -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $beta $beta v+s+.nc v+rho+.nc
fi

# eddy density flux w (definded at p-point)
if [ -f "w+rho+.nc" ]
then
  echo "w+rho+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,wrho_eddy -add -mul -setgrid,$wo_tm $alpha w+t+.nc -mul -setgrid,$wo_tm $beta w+s+.nc w+rho+.nc
fi


# Get partial derivates in x,y z direction
# dx (at p-point)
if [ -f "dx_u+rho+.nc" ]
then
  echo "dx_u+rho+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dx_urho_eddy -div -setgrid,$dlxp -sub u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp dx_u+rho+.nc
fi

# dy (at p-point)
if [ -f "dy_v+rho+.nc" ]
then
  echo "dy_v+rho+.nc exists"
else
  /pf/zmaw/m214003/local/bin/cdo -setname,dy_vrho_eddy -div -setgrid,$dlyp -sub v+rho+.nc -shifty,+1 v+rho+.nc $dlyp dy_v+rho+.nc
fi

# dz (at p-point)
if [ -f "dz_w+rho+.nc" ]
then
  echo "dz_w+rho+.nc exists"
else
# First interpolate w+rho+ on W-points:
  pfile="w+rho+.nc"
  wfile="w+rho+_w.nc"
  lvl=$(cdo showlevel $meta | tr " " ",")
  lvls=${lvl:1:400}
  cdo intlevelx,$lvls $pfile $wfile

# Then compute the vertical derivative from that
  ofile="dz_w+rho+.nc" # Output on p-point
  oname="dz_w+rho+" 
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
# /pf/zmaw/m214003/local/bin/cdo -setname,div_Urho_eddy -add -div -setgrid,$dlxp -sub u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp -div -setgrid,$dlyp -sub v+rho+.nc -shifty,+1 v+rho+.nc $dlyp div_U+rho+.nc
/pf/zmaw/m214003/local/bin/cdo -setname,div_Urho_eddy -add dz_w+rho+.nc -add dx_u+rho+.nc dy_v+rho+.nc div_Urho_eddy.nc

