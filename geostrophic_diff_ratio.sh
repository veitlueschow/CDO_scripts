#!/bin/bash
# 01/2017 Veit
# This script computes the magnitude of each geostrophic velocity (see geostrophic_timmean.sh) and model velocity and compares them to each other. 
# It also computes ratios between geostrophic and model output

# input: 
#box_uko.nc 
#box_vke.nc 
#box_ug.nc 
#box_vg.nc

# output: 
#geo_ratio_mag.nc
#geo_diff_mag.nc 

#geo_diff_u.nc 
#geo_diff_v.nc 
#geo_ratio_u.nc 
#geo_ratio_v.nc 



v_g=box_vg.nc
u_g=box_ug.nc
uko=box_uko.nc
vke=box_vke.nc

# get geo_ratio_mag.nc and geo_diff_mag.nc # NOT WORKING RIGHT NOW
cdo -sqrt -add -pow,2 $vke -pow,2 $uko velocity_mag.nc # velocity magnitude
cdo -sqrt -add -pow,2 $v_g -pow,2 $u_g geostrophic_mag.nc # geostrophic velocity magnitude
cdo -sub velocity_mag.nc geostrophic_mag.nc geo_diff_mag.nc # difference of magnitudes # OUTPUT
#cdo div geo_diff_mag.nc velocity_mag.nc geo_ratio_mag.nc # ratio of geo mag and vel mag # OUTPUT
#rm -f velocity_mag.nc # delete unwanted files: vel mag
#rm -f geostrophic_mag.nc # delete unwanted files: geo mag

# geo_ratio_u.nc, geo_ratio_v.nc, geo_ratio_mag.nc
cdo -pow,2 $vke vke_mag.nc # vke magnitude
cdo -pow,2 $uko uko_mag.nc # uko magnitude
cdo -pow,2 -sub $vke $v_g v_mag_diff.nc # difference vke mag - v_geo magnitude
cdo -pow,2 -sub $uko $u_g u_mag_diff.nc # difference uko mag - u_geo magnitude
#cdo div v_mag_diff.nc vke_mag.nc geo_ratio_v.nc # ratio on v OUTPUT
#cdo div u_mag_diff.nc uko_mag.nc geo_ratio_u.nc # ratio on u OUTPUT
# cdo -div -sqrt -pow,2 -sub $uko $u_g -sqrt -pow,2 $uko geo_ratio_u.nc
# cdo -div -sqrt -pow,2 -sub $vke $v_g -sqrt -pow,2 $vke geo_ratio_v.nc

# easiest way:
cdo -div -sub $vke $v_g $vke sijp_v.nc # OUTPUT
cdo -div -sub $uko $u_g $uko sijp_u.nc # OUTPUT
cdo -div -sub velocity_mag.nc geostrophic_mag.nc velocity_mag.nc sijp_mag.nc # OUTPUT

rm -f vke_mag.nc # delete unwanted files: v mag
rm -f uko_mag.nc # delete unwanted files: u mag
rm -f v_mag_diff.nc # delete unwanted files: v diff mag
rm -f u_mag_diff.nc # delete unwanted files: u diff mag

# get geo_diff_u.nc, geo_diff_v.nc, 
#cdo -sub -pow,2 $uko -pow,2 $u_g geo_diff_u.nc # OUTPUT
#cdo -sub -pow,2 $vke -pow,2 $v_g geo_diff_v.nc # OUTPUT



