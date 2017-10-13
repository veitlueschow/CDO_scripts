#!/bin/bash
# Veit Lüschow, 01/2016
# This script computes the geostrophic u- and v-velocity of time-averaged quantities
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

##Data file
idir=/work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/
ifile=tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_199*

#cdo select,level=519.5,1008.5,1516,1941.5,2472.5,2993,3449.5,name=po,year=1990/1999 $idir$ifile po.nc
#cdo select,level=519.5,1008.5,1516,1941.5,2472.5,2993,3449.5,name=zo,year=1990/1999 $idir$ifile zo.nc
#cdo select,level=519.5,1008.5,1516,1941.5,2472.5,2993,3449.5,name=uko,year=1990/1999 $idir$ifile uko.nc
#cdo select,level=519.5,1008.5,1516,1941.5,2472.5,2993,3449.5,name=vke,year=1990/1999 $idir$ifile vke.nc

cdo select,name=po,year=1990/1999 $idir$ifile po.nc
cdo select,name=zo,year=1990/1999 $idir$ifile zo.nc
cdo select,name=uko,year=1990/1999 $idir$ifile uko.nc
cdo select,name=vke,year=1990/1999 $idir$ifile vke.nc

# Optional: Select a rectangular box and compute averages
files=$(ls -t *.nc)

for f in $files	
do
	cdo timmean $f "box_"$f
	#cdo -timmean -selindexbox,1950,2600,400,1550 $f "box_"$f
done



/pf/zmaw/m214003/local/bin/cdo -mulc,-6856.713258185 -div -div -sub -shiftx,+1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlxu.nc -sin -mulc,0.01745329252 box_alat.nc box_vg1.nc
/pf/zmaw/m214003/local/bin/cdo -mulc,6856.713258185 -div -div -sub -shiftx,-1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlxu.nc -sin -mulc,0.01745329252 box_alat.nc box_vg-1.nc 
/pf/zmaw/m214003/local/bin/cdo -setgrid,box_dlyv.nc -chname,po,v_g -mulc,0.25 -add -add box_vg1.nc box_vg-1.nc -add -shifty,-1,cyclic box_vg1.nc -shifty,-1,cyclic box_vg-1.nc box_vg_CDO.nc 

/pf/zmaw/m214003/local/bin/cdo -mulc,-6856.713258185 -div -div -sub -shifty,+1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlyv.nc -sin -mulc,0.01745329252 box_alat.nc box_ug1.nc
/pf/zmaw/m214003/local/bin/cdo -mulc,6856.713258185 -div -div -sub -shifty,-1,cyclic -add box_po.nc -mulc,9.81 box_zo.nc -add box_po.nc -mulc,9.81 box_zo.nc box_dlyv.nc -sin -mulc,0.01745329252 box_alat.nc box_ug-1.nc
/pf/zmaw/m214003/local/bin/cdo -setgrid,box_dlxu.nc -chname,po,u_g -mulc,0.25 -add -add box_ug1.nc box_ug-1.nc -add -shiftx,-1,cyclic box_ug1.nc -shiftx,-1,cyclic box_ug-1.nc box_ug_CDO.nc 

cdo -div -sub box_ug_CDO.nc box_uko.nc box_uko.nc ratio_u.nc
cdo -div -sub box_vg_CDO.nc box_vke.nc box_vke.nc ratio_v.nc
cdo -div -sub -sqrt -add -pow,2 box_ug_CDO.nc -pow,2 box_vg_CDO.nc -sqrt -add -pow,2 box_uko.nc -pow,2 box_vke.nc -sqrt -add -pow,2 box_uko.nc -pow,2 box_vke.nc ratio_mag.nc 

cdo -sub -sqrt -add -pow,2 box_ug_CDO.nc -pow,2 box_vg_CDO.nc -sqrt -add -pow,2 box_uko.nc -pow,2 box_vke.nc diff_mag.nc 

cdo -div -sub -add -pow,2 box_ug_CDO.nc -pow,2 box_vg_CDO.nc -add -pow,2 box_uko.nc -pow,2 box_vke.nc -add -pow,2 box_uko.nc -pow,2 box_vke.nc ratio_energies.nc 




#There are two constants appearing in the commands:
# 65856.71326 = T/(4*pi) see equation above
# 0.017453 = pi/180 does the transformation from degree to rad for the latitude
