#!/bin/bash

#cdo rhopot -adisit ts.nc rhopoto_comp.nc

# input: tho_timemean.nc, sao_timemean.nc

tho_tm="../thetao.nc"
sao_tm="../so.nc"

cdo -b F64 -addc,0.1 $sao_tm sao_plusS.nc 

cdo merge sao_plusS.nc $tho_tm ts_plusS.nc

cdo rhopot -adisit ts_plusS.nc rhopoto_plusS_comp.nc

cdo -b F64 -addc,-0.1 $sao_tm sao_minusS.nc 

cdo merge sao_minusS.nc $tho_tm ts_minusS.nc

cdo rhopot -adisit ts_minusS.nc rhopoto_minusS_comp.nc

cdo -b F64 -mulc,-5.0 -sub rhopoto_minusS_comp.nc rhopoto_plusS_comp.nc beta.nc

