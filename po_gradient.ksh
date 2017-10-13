#!/bin/ksh

# Collection of commands
# These to lines compute the geostrophic u- and v-velocity out of the pressure po, the sea surface elevation zo, the distance at u-point/v-oint and the latitude alat


/pf/zmaw/m214003/local/bin/cdo -mulc,-6856.71326 -div -div -sub -shiftx,+1,cyclic -add box_geo_po -mulc,9.81 box_geo_zo -add box_geo_po -mulc,9.81 box_geo_zo dx -sin -mulc,0.017453 box_alat outy
/pf/zmaw/m214003/local/bin/cdo -mulc,6856.71326 -div -div -sub -shifty,-1,cyclic -add box_geo_po -mulc,9.81 box_geo_zo -add box_geo_po -mulc,9.81 box_geo_zo dy -sin -mulc,0.017453 box_alat outx
