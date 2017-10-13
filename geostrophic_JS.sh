#!/bin/ksh
#01/2017, Veit 
# This script computes geostrophic velocities from pressure and elevation based on a script by JS written in FORTRAN

#input:
# box_alat.nc
# box_po.nc
# nox_zo.nc
# box_dlxp.nc
# box_dlyp.nc
# size of box with length in x (ie) and y direction (je)

# ouput:
# box_vg.nc
# box_ug.nc

# First convert data to ext4 format
files=$(ls -t *.nc)

cdo -f ext copy 

for f in $files	
do
	e=${f%.*}
	cdo  -f ext copy $f $e".ext"
done

# construct INPUT file for Fortran program

# First for u-velocity

echo "&CTL nt = 1 ie=651 je=1151 ifile(1)="box_alat.ext" ifile(2)="box_dlyp.ext" ifile(3)="box_po.ext" ifile(4)="box_zo.ext" ofile="box_ug.ext" /" > INPUT

# execute fortran script 

~/progs_JS/u.out

# Then for v-velocity

echo "&CTL nt = 1 ie=651 je=1151 ifile(1)="box_alat.ext" ifile(2)="box_dlxp.ext" ifile(3)="box_po.ext" ifile(4)="box_zo.ext" ofile="box_vg.ext" /" > INPUT

# execute fortran script 

~/progs_JS/v.out

# now retransform to netCDF

cdo -f nc setgrid,box_uko.nc box_ug.ext box_ug_JS.nc
cdo -f nc setgrid,box_vke.nc box_vg.ext box_vg_JS.nc
