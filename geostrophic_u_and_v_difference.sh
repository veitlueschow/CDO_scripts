#!/bin/bash

# This script computes the magnitude of each geostrophic velocity (see geostrophic_timmean.sh) and model velocity and compares them to each other
v_g = box_vg.nc
u_g = box_ug.nc

cdo -sqrt -mul box_vke.nc box_vke.nc vke_mag.nc # vke magnitude
cdo -sqrt -mul box_uko.nc box_uko.nc uko_mag.nc # uko magnitude
cdo -sub -sqrt -mul box_vke.nc box_vke.nc -sqrt -mul $v_g $v_g v_geostrophic_diff.nc # difference vke - v_geo magnitude
cdo -sub -sqrt -mul box_uko.nc box_uko.nc -sqrt -mul $u_g $u_g u_geostrophic_diff.nc # difference uko - u_geo magnitude

cdo div v_geostrophic_diff.nc vke_mag.nc vke_geostrophic_ratio.nc # ratio on v
cdo div u_geostrophic_diff.nc vke_mag.nc uko_geostrophic_ratio.nc # ratio on u
