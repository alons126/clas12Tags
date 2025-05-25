#!/bin/tcsh

# To run: 
# chmod +x /lustre24/expphy/volatile/clas12/asportes/clas12Tags/refresh_GEMC_target.csh ; /lustre24/expphy/volatile/clas12/asportes/clas12Tags/refresh_GEMC_target.csh

cd /lustre24/expphy/volatile/clas12/asportes/clas12Tags/geometry_source/targets

echo ""
echo "${COLOR_START}==================================================================================================${COLOR_END}"
echo "${COLOR_START}= Running GEMC target display script                                                             =${COLOR_END}"
echo "${COLOR_START}==================================================================================================${COLOR_END}"
echo ""

echo "${COLOR_START}= Moving to ${TARGETS_DIR} =========${COLOR_END}"
echo "${COLOR_START}CLAS12TAGS_DIR:${COLOR_END} ${CLAS12TAGS_DIR}"
echo ""
cd ${TARGETS_DIR}
echo ""

echo "${COLOR_START}- Cleaning excessive file ------------------------------------------------------------------------${COLOR_END}"
echo ""
git clean -fxd
echo ""

echo "${COLOR_START}- Pulling repository -----------------------------------------------------------------------------${COLOR_END}"
echo ""
git reset --hard
git pull
echo ""

echo "${COLOR_START}HEAD:${COLOR_END}"
git log -1 --oneline
echo ""
