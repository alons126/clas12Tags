#!/bin/tcsh

# To run: 
# chmod +x /lustre24/expphy/volatile/clas12/asportes/clas12Tags/refresh_GEMC_target.csh ; /lustre24/expphy/volatile/clas12/asportes/clas12Tags/refresh_GEMC_target.csh

unset CLAS12TAGS_DIR
setenv CLAS12TAGS_DIR /lustre24/expphy/volatile/clas12/asportes/clas12Tags

unset TARGETS_DIR
setenv TARGETS_DIR ${CLAS12TAGS_DIR}/geometry_source/targets

unset GCARD_TO_RUN
setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_C.gcard
# setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_Ar.gcard



if (! $?COLOR_START) then
    unset COLOR_START
    setenv COLOR_START "\033[35m"
endif

if (! $?COLOR_END) then
    unset COLOR_END
    setenv COLOR_END "\033[0m"
endif

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
