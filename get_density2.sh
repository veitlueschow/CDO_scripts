#!/bin/bash

#cdo rhopot -adisit ts.nc rhopoto_comp.nc

# input: tho_timemean.nc, sao_timemean.nc

cdo addc,0.1 sao_timemean.nc sao_plusS.nc 

cdo merge sao_plusS.nc tho_timemean.nc ts_plusS.nc

cdo rhopot -adisit ts_plusS.nc rhopoto_plusS_comp.nc

cdo addc,-0.1 sao_timemean.nc sao_minusS.nc 

cdo merge sao_minusS.nc tho_timemean.nc ts_minusS.nc

cdo rhopot -adisit ts_minusS.nc rhopoto_minusS_comp.nc

cdo -mulc,-5.0 -sub rhopoto_minusS_comp.nc rhopoto_plusS_comp.nc beta.nc
