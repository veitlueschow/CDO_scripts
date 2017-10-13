#!/bin/bash
#This script computes the density fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields

# What is needed?

# tho_timemean.nc
# sao_timemean.nc
# alpha.nc
# beta.nc
# uko_timemean.nc
# vke_timemean.nc
# ut0_timemean.nc
# us0_timemean.nc
# vt0_timemean.nc
# vs0_timemean.nc
# dlxp.nc
# dlyp.nc

# wmo_tm.nc
# ws0_tm.nc
# wt0_tm.nc
# rhoref = 1025 kg/m^3

beta="/work/mh0256/m300522/meta_storm/beta.nc"
alpha="/work/mh0256/m300522/meta_storm/alpha.nc"
dlxp="/work/mh0256/m300522/meta_storm/dlxp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp.nc"
area="/work/mh0256/m300522/meta_storm/areap.nc"

#tho_tm="tho_timemean.nc"
#sao_tm="sao_timemean.nc"
#uko_tm="uko_timemean.nc"
#vke_tm="vke_timemean.nc"
#vs0_tm="vs0_timemean.nc"
#vt0_tm="vt0_timemean.nc"
#us0_tm="us0_timemean.nc"
#ut0_tm="ut0_timemean.nc"

idir="/work/mh0256/m300522/data_storm/tape/1960s/"

tho_tm=$idir"tho_tm.nc"
sao_tm=$idir"sao_tm.nc"
uko_tm=$idir"uko_tm.nc"
vke_tm=$idir"vke_tm.nc"
vs0_tm=$idir"vs0_tm.nc"
vt0_tm=$idir"vt0_tm.nc"
us0_tm=$idir"us0_tm.nc"
ut0_tm=$idir"ut0_tm.nc"

wo_tm=$idir"wo_p_tm.nc"
ws0_tm=$idir"ws0_p_tm.nc"
wt0_tm=$idir"wt0_p_tm.nc"

# eddy temp flux u
/pf/zmaw/m214003/local/bin/cdo -setname,ut_eddy -sub $ut0_tm -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $tho_tm $tho_tm $uko_tm u+t+.nc 

# eddy salt flux u
/pf/zmaw/m214003/local/bin/cdo -setname,us_eddy -sub $us0_tm -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $sao_tm $sao_tm $uko_tm u+s+.nc 

# eddy temp flux v
/pf/zmaw/m214003/local/bin/cdo -setname,vt_eddy -sub $vt0_tm -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $tho_tm $tho_tm $vke_tm v+t+.nc

# eddy salt flux v
/pf/zmaw/m214003/local/bin/cdo -setname,vs_eddy -sub $vs0_tm -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $sao_tm $sao_tm $vke_tm v+s+.nc

# eddy temp flux w
/pf/zmaw/m214003/local/bin/cdo -setname,wt_eddy -sub $wt0_tm -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $tho_tm $tho_tm $wo_tm w+t+.nc

# eddy salt flux w
/pf/zmaw/m214003/local/bin/cdo -setname,ws_eddy -sub $ws0_tm -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $sao_tm $sao_tm $wo_tm w+s+.nc


# eddy density flux u
/pf/zmaw/m214003/local/bin/cdo -setname,urho_eddy -add -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $alpha $alpha u+t+.nc -mul -setgrid,$uko_tm -mulc,0.5 -add -shiftx,-1,cyclic $beta $beta u+s+.nc u+rho+.nc
# eddy density flux v
/pf/zmaw/m214003/local/bin/cdo -setname,vrho_eddy -add -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $alpha $alpha v+t+.nc -mul -setgrid,$vke_tm -mulc,0.5 -add -shifty,-1,cyclic $beta $beta v+s+.nc v+rho+.nc
# eddy density flux w
/pf/zmaw/m214003/local/bin/cdo -setname,wrho_eddy -add -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $alpha $alpha w+t+.nc -mul -setgrid,$wo_tm -mulc,0.5 -add -shifty,-1,cyclic $beta $beta w+s+.nc w+rho+.nc

# Get Divergence, but first the two derivatives
# dx
/pf/zmaw/m214003/local/bin/cdo -setname,dx_urho_eddy -div -setgrid,$dlxp -sub u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp dx_u+rho+.nc
# dy
/pf/zmaw/m214003/local/bin/cdo -setname,dy_vrho_eddy -div -setgrid,$dlyp -sub v+rho+.nc -shifty,+1 v+rho+.nc $dlyp dy_v+rho+.nc
# add the two
/pf/zmaw/m214003/local/bin/cdo -setname,div_Urho_eddy -add -div -setgrid,$dlxp -sub u+rho+.nc -shiftx,+1 u+rho+.nc $dlxp -div -setgrid,$dlyp -sub v+rho+.nc -shifty,+1 v+rho+.nc $dlyp div_U+rho+.nc
 

