#!/bin/bash
#This script computes the density fluxes and the divergence, needed is the time mean circulation uko, vke as weill as the time mean residual flux u*T and u*S and the coefficients alpha, beta to get the density fields

# What is needed?
# tho_timemean.nc
# sao_timemean.nc
# alpha,nc
# beta.nc
# uko_timemean.nc
# vke_timemean.nc
# ut0_timemean.nc
# us0_timemean.nc
# vt0_timemean.nc
# vs0_timemean.nc

# eddy temp flux u
/pf/zmaw/m214003/local/bin/cdo -sub ut0_timemean.nc -mul -setgrid,uko_timemean.nc -mulc,0.5 -add -shiftx,-1,cyclic tho_timemean.nc tho_timemean.nc uko_timemean.nc u+t+.nc 

# eddy salt flux u
/pf/zmaw/m214003/local/bin/cdo -sub us0_timemean.nc -mul -setgrid,uko_timemean.nc -mulc,0.5 -add -shiftx,-1,cyclic sao_timemean.nc sao_timemean.nc uko_timemean.nc u+s+.nc 

# eddy temp flux v
/pf/zmaw/m214003/local/bin/cdo -sub vt0_timemean.nc -mul -setgrid,vke_timemean.nc -mulc,0.5 -add -shifty,-1,cyclic tho_timemean.nc tho_timemean.nc vke_timemean.nc v+t+.nc

# eddy salt flux v
/pf/zmaw/m214003/local/bin/cdo -sub vs0_timemean.nc -mul -setgrid,vke_timemean.nc -mulc,0.5 -add -shifty,-1,cyclic sao_timemean.nc sao_timemean.nc vke_timemean.nc v+s+.nc


# eddy density flux u
/pf/zmaw/m214003/local/bin/cdo -add -mul -setgrid,uko_timemean.nc -mulc,0.5 -add -shiftx,-1,cyclic alpha.nc alpha.nc u+t+.nc -mul -setgrid,uko_timemean.nc -mulc,0.5 -add -shiftx,-1,cyclic beta.nc beta.nc u+s+.nc u+rho+.nc
# eddy density flux v
/pf/zmaw/m214003/local/bin/cdo -add -mul -setgrid,vke_timemean.nc -mulc,0.5 -add -shifty,-1,cyclic alpha.nc alpha.nc v+t+.nc -mul -setgrid,vke_timemean.nc -mulc,0.5 -add -shifty,-1,cyclic beta.nc beta.nc v+s+.nc v+rho+.nc

# Get Divergence, but first the two derivatives
# dx
/pf/zmaw/m214003/local/bin/cdo -div -setgrid,dlxp.nc -sub u+rho+.nc -shiftx,+1 u+rho+.nc dlxp.nc dx_u+rho+.nc
# dy
/pf/zmaw/m214003/local/bin/cdo -div -setgrid,dlyp.nc -sub v+rho+.nc -shifty,+1 v+rho+.nc dlyp.nc dy_v+rho+.nc
# add the two
/pf/zmaw/m214003/local/bin/cdo -add -div -setgrid,dlxp.nc -sub u+rho+.nc -shiftx,+1 u+rho+.nc dlxp.nc -div -setgrid,dlyp.nc -sub v+rho+.nc -shifty,+1 v+rho+.nc dlyp.nc div_U+rho+.nc
 

