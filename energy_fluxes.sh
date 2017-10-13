#!/bin/bash
ulimit -s unlimited
# get energy conversion terms according to JS von Storch 2012: mean potential to eddy potential

urho_eddy="urho_eddy.nc"
vrho_eddy="vrho_eddy.nc"
dx_rhopoto="dx_rhopoto.nc"
dy_rhopoto="dy_rhopoto.nc"
dz_rhopoto="dz_rhopoto.nc"

# 3D
#/pf/zmaw/m214003/local/bin/cdo -add -mul w+rho+.nc dz_rhopoto.nc -add -mul -mulc,0.5 -add u+rho+.nc -shiftx,-1,cyclic u+rho+.nc dx_rhopoto.nc -mul -mulc,0.5 -add v+rho+.nc -shifty,-1,cyclic v+rho+.nc dy_rhopoto.nc Pe2Pm_3D.nc

# Horizontal

/pf/zmaw/m214003/local/bin/cdo -setname,Pe2Pm -mulc,-9.81 -div -add -mul -mulc,0.5 -setgrid,$dx_rhopoto -add $urho_eddy -shiftx,+1,coord,cyclic $urho_eddy $dx_rhopoto -mul -mulc,0.5 -setgrid,$dx_rhopoto -add $vrho_eddy -shifty,+1,coord,cyclic $vrho_eddy $dy_rhopoto $dz_rhopoto Pe2Pm_hor.nc	
