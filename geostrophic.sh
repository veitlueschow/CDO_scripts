#!/bin/bash
# Veit Lüschow, 01/2016
# This script computes the geostrophic u- and v-velocity 
# Input: pressure po, sea surface elevation zo, distance at u-point/v-oint and the latitude alat

# u_geostrophic = -1/f * dp/dy; v_geostrophic = 1/f dp/dx with p = po + zo*g = po + zo*9.81
# f = 2*omega*sin(lat) with omea = 2*pi/T where T is the period of Earth's rotation 
# This leads to:
# u_geostrophic = -T/(4*pi*sin(lat))*dp/dy; v_geostrophic = T/(4*pi*sin(lat))*dp/dx



# First get input files from server
#Meta file
metafile=/pool/data/MPIOM/TP6M/TP6ML80_fx.nc

cdo select,level=1941.5,name=alat $metafile alat.nc
cdo select,level=1941.5,name=dlxu $metafile dlxu.nc
cdo select,level=1941.5,name=dlyv $metafile dlyv.nc

#Data file
idir=/work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/
ifile=tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_2009-01-01_2009-03-31

cdo select,level=1941.5,name=po,timestep=1 $idir$ifile po.nc
cdo select,level=1941.5,name=zo,timestep=1 $idir$ifile zo.nc
cdo select,level=1941.5,name=uko,timestep=1 $idir$ifile uko.nc
cdo select,level=1941.5,name=vke,timestep=1 $idir$ifile vke.nc

# Optional: Select a rectangular box
files=$(ls -t *.nc)

for f in $files	
do
	cdo selindexbox,1950,2600,400,1550 $f "box_"$f
done



/pf/zmaw/m214003/local/bin/cdo -setgrid,dlyv.nc -chname,po,v_g -mulc,-6856.71326 -div -div -sub -shiftx,+1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlxu.nc -sin -mulc,0.017453 box_alat.nc v_geostrophic.nc
/pf/zmaw/m214003/local/bin/cdo -setgrid,dlxu.nc -chname,po,u_g -mulc,6856.71326 -div -div -sub -shifty,-1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlyv.nc -sin -mulc,0.017453 box_alat.nc u_geostrophic.nc

#There are two constants appearing in the commands:
# 65856.71326 = T/(4*pi) see equation above
# 0.017453 = pi/180 does the transformation from degree to rad for the latitude
