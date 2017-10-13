#!/bin/bash

#cdo rhopot -adisit ts.nc rhopoto_comp.nc

# input: tho_timemean.nc, sao_timemean.nc

tho_tm="../thetao.nc"
sao_tm="../so.nc"

cdo -b F64 -addc,0.1 $tho_tm tho_plusT.nc 

cdo merge tho_plusT.nc $sao_tm ts_plusT.nc

cdo rhopot -adisit ts_plusT.nc rhopoto_plusT_comp.nc

cdo -b F64 -addc,-0.1 $tho_tm tho_minusT.nc 

cdo merge tho_minusT.nc $sao_tm ts_minusT.nc

cdo rhopot -adisit ts_minusT.nc rhopoto_minusT_comp.nc

cdo -b F64 -mulc,-5.0 -sub rhopoto_minusT_comp.nc rhopoto_plusT_comp.nc alpha.nc
