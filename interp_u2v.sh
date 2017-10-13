#!/bin/bash
# This script interpolates a quantity from the u-points to the v-points, extrapolating at the boundaries

meta="/work/mh0256/m300522/data_storm/tape/2000s/vke_tm2001-2010.nc"
ifile="uv0_tm2001-2010.nc"
ofile="uv0_v_tm2001-2010.nc"


/pf/zmaw/m214003/local/bin/cdo -setgrid,$meta -mulc,0.25 -add -add $ifile -shiftx,+1,cyclic $ifile -add -shifty,-1,cyclic $ifile -shiftx,+1,cyclic $ifile $ofile
