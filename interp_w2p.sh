#!/bin/bash
# This script interpolates a quantity from the p-points to the w-points, extrapolating at the boundaries

meta="/work/mh0256/m300522/data_storm/tape/2000s/rhopoto_tm2001-2010.nc"
ifile="wo_tm2001-2010.nc"
ofile="wo_p_tm2001-2010.nc"
lvl=$(cdo showlevel $meta | tr " " ",")
lvls=${lvl:1:600}
echo $lvls
cdo -setgrid,$meta -intlevel,$lvls $ifile $ofile
