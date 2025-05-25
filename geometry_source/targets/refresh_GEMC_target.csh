#!/bin/tcsh

unset CLAS12TAGS_DIR
setenv CLAS12TAGS_DIR /lustre24/expphy/volatile/clas12/asportes/clas12Tags

unset TARGETS_DIR
setenv TARGETS_DIR ${CLAS12TAGS_DIR}/geometry_source/targets

unset GCARD_TO_RUN
setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_C.gcard
# setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_Ar.gcard

echo "${COLOR_START}= switching into gemc/dev module =================================================================${COLOR_END}"
echo ""
module switch gemc/dev
echo ""

echo "${COLOR_START}= Resetting GEMC_DATA_DIR ========================================================================${COLOR_END}"
echo ""
setenv GEMC_DATA_DIR ${CLAS12TAGS_DIR}
echo "${COLOR_START}GEMC_DATA_DIR:${COLOR_END} ${GEMC_DATA_DIR}"
echo ""

# echo "${COLOR_START}= reconfiguring targets ====================================================="
# ./targets.pl config.dat
# echo ""

# echo "${COLOR_START}= coping geometry files to experiments repository ==========================="
# cp -r ./*.txt /Users/alon/Projects/clas12Tags/experiments/clas12/targets
# # rm -r ./*.txt
# echo ""

echo "${COLOR_START}= running gemc with GCARD_TO_RUN ============================================${COLOR_END}"
echo ""
echo "${COLOR_START}GCARD_TO_RUN:${COLOR_END} ${GCARD_TO_RUN}"
echo ""
gemc ${GCARD_TO_RUN}
echo ""
