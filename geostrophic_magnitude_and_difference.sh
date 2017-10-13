#!/bin/bash

# This script computes the magnitude of each geostrophic velocity (see geostrophic_timmean.sh) and model velocity and compares them to each other
v_g = box_vg.nc
u_g = box_ug.nc

cdo -sqrt -add -mul box_vke.nc box_vke.nc -mul box_uko.nc box_uko.nc velocity_mag.nc # velocity magnitude
cdo -sqrt -add -mul $v_g $v_g -mul $u_g $u_g geostrophic_mag.nc # geostrophic velocity magnitude
cdo -sub -sqrt -add -mul box_vke.nc box_vke.nc -mul box_uko.nc box_uko.nc -sqrt -add -mul $v_g $v_g -mul $u_g $u_g velocity_geostrophic_diff.nc # difference of both
cdo div velocity_geostrophic_diff.nc velocity_mag.nc velocity_geostrophic_ratio.nc
