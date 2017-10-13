#!/bin/bash
ulimit -s unlimited

# Computes density variance from mean density and rpotrpot0
# Veit September 2017

idir="/work/mh0256/m300522/data_storm/tape/2000s/"
time="2001-2010"

rho=$idir"rhopoto_tm"$time".nc"
rpotrpot=$idir"rpotrpot0_tm"$time".nc"


cdo -setname,rhorho_eddy -setgrid,$rho -sub $rpotrpot -sqr $rho rhorho_eddy.nc
