#!/bin/bash

# This script Computes the vertical derivative at the p point of a quantity that is defined at the w point of each grid point. The input data has to have 81 level, the ouput has 80 
# as an additional input, the file levellist.txt has to be provided that contains both the levels at p and at w points in numerical order

var=""
while read f; do
	var=$var","$f
done < /work/mh0256/m300522/meta_storm/levellist.txt
lvls=${var:1:1000}

cdo -setname,dz_ -div -sub -sellevidx,1/80 tho_w.nc -sellevidx,2/81 tho_w.nc ddpo.nc dz_tho_.nc 

cdo chlevel,$lvls dz_tho_.nc dz_tho.nc

rm -f dz_tho_.nc
