#!/bin/bash

#cdo select,year=1980/2010,name=tho /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* tho_all.nc
#cdo timmean tho_all.nc tho_timemean.nc
#cdo select,year=1980/2010,name=sao /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* sao_all.nc
#cdo timmean sao_all.nc sao_timemean.nc

#cdo select,year=1980/2010,name=ut0 /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* ut0_all.nc
#cdo select,year=1980/2010,name=vt0 /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* vt0_all.nc
cdo timmean uko_all.nc uko_timemean_all.nc
cdo timmean vke_all.nc vke_timemean_all.nc
cdo select,year=1980/2010,name=uko /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* wo_all.nc
cdo timmean wo_all.nc wo_timemean.nc


cdo select,year=1980/2010,name=wt0 /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* wt0_all.nc
cdo timmean wt0_all.nc wt0_timemean.nc
cdo select,year=1980/2010,name=ws0 /work/im0454/m211054/experiments/tp6ml80_srtm30plus_ncep/outdata/tp6ml80_srtm30plus_ncep_mpiom_data_mm.nc_* ws0_all.nc
cdo timmean ws0_all.nc ws0_timemean.nc
