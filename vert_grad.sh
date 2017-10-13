#!/bin/bash

# Computes the vertical derivative at the p point of a quantity that is defined at the w point of each grid point. The input data has to have 81 level, the ouput has 80 
# Veit march 2017

ifile="tho_w.nc" # Input on w-point
ofile="dz_tho.nc" # Output on p-point
oname="dz_tho" 
meta="tho.nc" # Needed to get the p-point levels
ddpo="ddpo.nc" # layer thickness

cdo -setname,$oname -div -sub -sellevidx,1/80 $ifile -sellevidx,2/81 $ifile $ddpo tmp.nc 

a=$(cdo showlevel tmp.nc)
b=$(cdo showlevel $meta)
c=$(echo $a" "$b|tr " " "\n"|sort -g)
lvls=$(echo $c | tr " " ",")

cdo chlevel,$lvls tmp.nc $ofile

rm -f tmp.nc
