#!/bin/bash
# get thickness diffusivity according to Nakamura 2000



dz_rho="../dz_rhopoto.nc" # p-point
dx_rho="../dx_rhopoto.nc" # p-point
dy_rho="../dy_rhopoto.nc" # p-point

divUrho="../div_Urho_eddy.nc" # p-point

ddpo="/work/mh0256/m300522/meta_storm/ddpo_dp.nc" # layer thickness
dlxp="/work/mh0256/m300522/meta_storm/dlxp_dp.nc"
dlyp="/work/mh0256/m300522/meta_storm/dlyp_dp.nc"

#----------------------------------------------------- First term demoninator den1
if [ -f "den1.nc" ]
then
  echo "den1.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,den1 -mul $dz_rho -div -sub -shiftx,-1,cyclic -div $dx_rho $dz_rho -shiftx,+1,cyclic -div $dx_rho $dz_rho -mulc,2. $dlxp den1.nc
fi

#----------------------------------------------------- Second term demoninator den2
if [ -f "den2.nc" ]
then
  echo "den2.nc exists"
else
	/pf/zmaw/m214003/local/bin/cdo -setname,den2 -mul $dz_rho -div -sub -shifty,-1,cyclic -div $dy_rho $dz_rho -shifty,+1,cyclic -div $dy_rho $dz_rho -mulc,2. $dlyp den2.nc
fi

#----------------------------------------------------- Third term demoninator den3
if [ -f "den3.nc" ]
then
  echo "den3.nc exists"
else
	# Get fraction first
	
	cdo div $dx_rho $dz_rho tmp1.nc
	
	# Get interpolation on w-points
	meta="/work/mh0256/m300522/data_storm/tape/60-90/wo_60-90_tm.nc"
	ifile="tmp1.nc"
	ofile="tmp2.nc"
	lvl=$(cdo showlevel $meta | tr " " ",")
	lvls=${lvl:1:400}
	#echo $lvls
	cdo intlevelx,$lvls $ifile $ofile
	
	# Get vertical derivative
	
	cdo -div -sub -sellevidx,1/80 tmp2.nc -sellevidx,2/81 tmp2.nc $ddpo tmp3.nc # at p-point
	a=$(cdo showlevel tmp3.nc)
	b=$(cdo showlevel $dz_rho)
	c=$(echo $a" "$b|tr " " "\n"|sort -g)
	lvls=$(echo $c | tr " " ",")
	cdo chlevel,$lvls tmp3.nc tmp4.nc
	
	cdo -setname,den3 -mul $dx_rho tmp4.nc den3.nc
	
	rm -f tmp*.nc
fi

#----------------------------------------------------- Fourth term demoninator den4
if [ -f "den4.nc" ]
then
  echo "den4.nc exists"
else
	# Get fraction first
	cdo div $dy_rho $dz_rho tmp1.nc
	
	# Get interpolation on w-points
	meta="/work/mh0256/m300522/data_storm/tape/60-90/wo_60-90_tm.nc"
	ifile="tmp1.nc"
	ofile="tmp2.nc"
	lvl=$(cdo showlevel $meta | tr " " ",")
	lvls=${lvl:1:400}
	#echo $lvls
	cdo intlevelx,$lvls $ifile $ofile
	
	# Get vertical derivative
	
	cdo -div -sub -sellevidx,1/80 tmp2.nc -sellevidx,2/81 tmp2.nc $ddpo tmp3.nc # at p-point
	a=$(cdo showlevel tmp3.nc)
	b=$(cdo showlevel $dz_rho)
	c=$(echo $a" "$b|tr " " "\n"|sort -g)
	lvls=$(echo $c | tr " " ",")
	cdo chlevel,$lvls tmp3.nc tmp4.nc
	
	cdo -setname,den4 -mul $dy_rho tmp4.nc den4.nc
	
	rm -f tmp*.nc
fi

#----------------------------------------------------- Put everything together

cdo add den1.nc den2.nc tmp1.nc
cdo add den3.nc den4.nc tmp2.nc
cdo -setname,kappa_nakamura -div -mulc,-1. $divUrho -sub tmp1.nc tmp2.nc kappa_nakamura.nc

rm -f tmp*.nc

