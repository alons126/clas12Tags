#!/bin/tcsh

unset CLAS12TAGS_DIR
setenv CLAS12TAGS_DIR /lustre24/expphy/volatile/clas12/asportes/clas12Tags

unset TARGETS_DIR
setenv TARGETS_DIR ${CLAS12TAGS_DIR}/geometry_source/targets

unset GCARD_TO_RUN
setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rga_spring2018.gcard
# setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_C.gcard
# setenv GCARD_TO_RUN ${TARGETS_DIR}/target_text_rgm_fall2021_Ar.gcard

if (! $?COLOR_START) then
    unset COLOR_START
    setenv COLOR_START "\033[35m"
endif

if (! $?COLOR_END) then
    unset COLOR_END
    setenv COLOR_END "\033[0m"
endif
