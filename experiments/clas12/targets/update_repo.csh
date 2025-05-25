#!/bin/tcsh

# To run: 
# source /lustre24/expphy/volatile/clas12/asportes/Ar40_imp_GEMC/clas12Tags/geometry_source/targets/update_and_refresh_target.csh

cd /lustre24/expphy/volatile/clas12/asportes/Ar40_imp_GEMC/clas12Tags/geometry_source/targets

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
