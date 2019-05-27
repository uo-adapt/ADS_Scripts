#!/usr/bin/env bash

###################################################################
#  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  #
###################################################################


###################################################################
# This design file stores the values of all variables required to
# execute a complete neuroimage processing pipeline. You may
# execute the analysis specified in this design file by calling
# (in any v4 or higher bash terminal):
#
# xcpEngine -d <design> -c <cohort> -o <output> <options>
#
# Variables fall into five general categories:
# * ANALYSIS VARIABLES are used at all stages of this analysis.
# * PIPELINE specifies the modules that comprise the analysis.
# * MODULE VARIABLES are used during one stage of the analysis.
#                  These are typically array variables with array
#                  indices equal to the index of the module that
#                  calls them.
# * OUTPUT VARIABLES may be used at all stages of the analysis.
#                  These are typically array variables with array
#                  indices equal to the value of the primary
#                  subject identifier. They will appear only in
#                  localised design files.
###################################################################


###################################################################
# ANALYSIS VARIABLES
###################################################################

analysis=fc_$(whoami)
design=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_201903131537_1.dsn
sequence=anatomical
standard=MNI%2x2x2

###################################################################
# PIPELINE
###################################################################

pipeline=prestats,confound2,regress,fcon,reho,alff,roiquant,qcfc

###################################################################
# 1 PRESTATS
###################################################################

prestats_rerun[1]=0
prestats_cleanup[1]=1
prestats_process[1]=FMP

###################################################################
# 2 CONFOUND2
###################################################################

confound2_rps[2]=0
confound2_rms[2]=0
confound2_wm[2]=1
confound_wm_ero[2]=5
confound2_csf[2]=1
confound_csf_ero[2]=10
confound2_gsr[2]=1
confound2_acompcor[2]=0
confound2_tcompcor[2]=0
confound2_aroma[2]=1
confound2_past[2]=0
confound2_dx[2]=0
confound2_sq[2]=1
confound2_censor[2]=0
confound2_censor_contig[2]=0
confound2_rerun[2]=0
confound2_cleanup[2]=1

###################################################################
# 3  REGRESS
###################################################################

regress_tmpf[3]=butterworth
regress_hipass[3]=0.01
regress_lopass[3]=0.08
regress_tmpf_order[3]=1
regress_tmpf_pass[3]=2
regress_tmpf_ripple[3]=0.5
regress_tmpf_ripple2[3]=20
regress_dmdt[3]=2
regress_1ddt[3]=1
regress_smo[3]=2
regress_sptf[3]=susan
regress_usan[3]=default
regress_usan_space[3]=
regress_rerun[3]=0
regress_cleanup[3]=1
regress_process[3]=DMT-TMP-REG

###################################################################
# 4 FCON
###################################################################

fcon_atlas[4]=gordon333
fcon_metric[4]=corrcoef
fcon_thr[4]=N
fcon_window[4]=10
fcon_pad[4]=FALSE
fcon_rerun[4]=0
fcon_cleanup[4]=1

###################################################################
# 5 REHO
###################################################################

reho_nhood[5]=vertices
reho_roikw[5]=0 # does nothing at the moment
reho_sptf[5]=susan
reho_smo[5]=2
reho_rerun[5]=0
reho_cleanup[5]=1

###################################################################
# 6 ALFF
###################################################################

alff_hipass[6]=0.01
alff_lopass[6]=0.08
alff_sptf[6]=susan
alff_smo[6]=2
alff_rerun[6]=0
alff_cleanup[6]=1

###################################################################
# 7 ROIQUANT
###################################################################

roiquant_atlas[7]=gordon333
roiquant_globals[7]=1
roiquant_vol[7]=1
roiquant_rerun[7]=0
roiquant_cleanup[7]=1


##################################################################
# 8 QCFC
###################################################################
qcfc_atlas[8]=gordon333
qcfc_sig[8]=fdr
qcfc_rerun[8]=0
qcfc_cleanup[8]=1
