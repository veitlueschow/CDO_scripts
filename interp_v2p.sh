#!/bin/bash
# This script interpolates a quantity from the v-points to the p-points, extrapolating at the boundaries

meta="/work/mh0256/m300522/data_storm/tape/2000s/rhopoto_tm2001-2010.nc"
ifile="vke.nc"
ofile="vke_p.nc"

/pf/zmaw/m214003/local/bin/cdo -setgrid,$meta -mulc,0.5 -add -shifty,+1,cyclic,coord $ifile $ifile $ofile
