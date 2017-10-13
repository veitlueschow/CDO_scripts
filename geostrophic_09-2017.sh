#!/bin/bash

# First get Coriolis parameter for u- and v-point

alatu="/work/mh0256/m300522/meta_storm/alatu.nc"
alatv="/work/mh0256/m300522/meta_storm/alatv.nc"

metau="/work/mh0256/m300522/data_storm/tape/2000s/uko_tm2001-2010.nc"
metav="/work/mh0256/m300522/data_storm/tape/2000s/vke_tm2001-2010.nc"

dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"

ftwov="/work/mh0256/m300522/meta_storm/ftwov.nc"
ftwou="/work/mh0256/m300522/meta_storm/ftwou.nc"

po="/work/mh0256/m300522/data_storm/tape/2000s/po_tm2001-2010.nc"
zo="/work/mh0256/m300522/data_storm/tape/2000s/zo_tm2001-2010.nc"
p="pfull.nc"

# u-point
#cdo setgrid,$metau -mulc,12.566371 -divc,86164 -sin -mulc,0.017453 $alatu ftwou.nc  
# v-point
#cdo setgrid,$metav -mulc,12.566371 -divc,86164 -sin -mulc,0.017453 $alatv ftwov.nc

# Get sum of surface elevation pressure and pressure
cdo -add -mulc,9.81 $zo $po pfull.nc

# Now get geostrophic velocity in u-direction
# upper
/pf/zmaw/m214003/local/bin/cdo -mulc,-1 -div -sub -shifty,+1,coord,cyclic $p $p -shifty,+1,cyclic -mul $ftwov $dlyp wup.nc
# lower
/pf/zmaw/m214003/local/bin/cdo -mulc,-1 -div -sub $p -shifty,-1,cyclic $p -mul $ftwov $dlyp wdown.nc

# Sum up
/pf/zmaw/m214003/local/bin/cdo -setname,u_geostrophic -setgrid,$metau -mulc,0.25 -add -add wup.nc -shiftx,-1,cyclic wup.nc -add wdown.nc -shiftx,-1,cyclic wdown.nc ug.nc 

rm -f wup.nc
rm -f wdown.nc

# Now get geostrophic velocity in v-direction
# left
/pf/zmaw/m214003/local/bin/cdo -div -sub $p -shiftx,+1,cyclic $p -shiftx,+1,cyclic -mul $ftwou $dlxp wleft.nc
# right
/pf/zmaw/m214003/local/bin/cdo -div -sub -shiftx,-1,coord,cyclic $p $p -mul $ftwou $dlxp wright.nc

# Sum up
/pf/zmaw/m214003/local/bin/cdo -setname,v_geostrophic -setgrid,$metav -mulc,0.25 -add -add wleft.nc -shifty,-1,cyclic wleft.nc -add wright.nc -shifty,-1,cyclic wright.nc vg.nc 

rm -f wright.nc
rm -f wleft.nc
rm -f pfull.nc


# How to get Jochems measure for geostrophy
# Check get_jochems_measure.sh
