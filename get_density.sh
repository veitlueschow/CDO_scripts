#!/bin/bash

#cdo rhopot -adisit ts.nc rhopoto_comp.nc

# input: tho_timemean.nc, sao_timemean.nc

cdo addc,0.1 tho_timemean.nc tho_plusT.nc 

cdo merge tho_plusT.nc sao_timemean.nc ts_plusT.nc

cdo rhopot -adisit ts_plusT.nc rhopoto_plusT_comp.nc

cdo addc,-0.1 tho_timemean.nc tho_minusT.nc 

cdo merge tho_minusT.nc sao_timemean.nc ts_minusT.nc

cdo rhopot -adisit ts_minusT.nc rhopoto_minusT_comp.nc

cdo -mulc,-5.0 -sub rhopoto_minusT_comp.nc rhopoto_plusT_comp.nc alpha.nc
