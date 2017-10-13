#!/bin/bash
# This script interpolates a quantity from the p-points to the w-points, extrapolating at the boundaries

meta="wmo_tm2001-2010.nc"
ifile="rhopoto_tm2001-2010.nc"
ofile="rhopoto_w_tm2001-2010.nc"
lvl=$(cdo showlevel $meta | tr " " ",")
lvls=${lvl:1:400}
#echo $lvls
cdo -setgrid,$meta -intlevelx,$lvls $ifile $ofile
