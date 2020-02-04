#!/usr/bin/env bash

###################################################################
#  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  #
###################################################################

###################################################################
# SPECIFIC MODULE HEADER
# This module aligns the analyte image to a high-resolution target.
###################################################################
mod_name_short=scorescrub
mod_name='CBF score and scrubbing'
mod_head=${XCPEDIR}/core/CONSOLE_MODULE_RC

###################################################################
# GENERAL MODULE HEADER
###################################################################
source ${XCPEDIR}/core/constants
source ${XCPEDIR}/core/functions/library.sh
source ${XCPEDIR}/core/parseArgsMod

###################################################################
# MODULE COMPLETIO
###################################################################
completion() {
   source ${XCPEDIR}/core/auditComplete
   source ${XCPEDIR}/core/updateQuality
   source ${XCPEDIR}/core/moduleEnd
}

##################################################################
# OUTPUTS
###################################################################
derivative            cbfscrub                  ${prefix}_cbfscrub.nii.gz
derivative            cbfscorets                ${prefix}_cbfscore_ts.nii.gz   
derivative            cbfscore                  ${prefix}_cbfscore.nii.gz
derivative            cbfscoreR                 ${prefix}_cbfscoreR.nii.gz 
derivative            cbfscrubR                 ${prefix}_cbfscrubR.nii.gz
derivative            cbfscrubZ                 ${prefix}_cbfscrubZ.nii.gz
derivative            cbfscoreZ                 ${prefix}_cbfscoreZ.nii.gz
derivative            cbfscore_tsnr             ${prefix}_cbfscore_tsnr.nii.gz 

output                cbfscorets               ${prefix}_cbfscore_ts.nii.gz   
output                cbfscrub                 ${prefix}_cbfscrub.nii.gz
output                cbfsore                  ${prefix}_cbfsore.nii.gz
output                cbfscoreR                ${prefix}_cbfscoreR.nii.gz
output                cbfscrubR                ${prefix}_cbfscrubR.nii.gz
output                cbfscrubZ                ${prefix}_cbfscrubZ.nii.gz
output                cbfscoreZ                ${prefix}_cbfscoreZ.nii.gz
output                cbfscore_tsnr            ${prefix}_cbfscore_tsnr.nii.gz 

qc nvoldel  nvoldel  ${prefix}_nvoldel.txt 


derivative_set       cbfscrub            Statistic         mean
derivative_set       cbfscore            Statistic         mean
derivative_set       cbfscoreR    Statistic         mean
derivative_set       cbfscrubR    Statistic         mean
derivative_set       cbfscore_tsnr       Statistic         mean
derivative_set       cbfscoreZ      Statistic         mean 
derivative_set       cbfscrubZ     Statistic         mean 

process              cbfscorets        ${prefix}_cbfscore_ts


if ! is_image ${cbfscrub[cxt]}
 then 
    subroutine  @1.2 computing cbf score
  # obtain the score 
        exec_xcp score.R                 \
             -i     ${cbf_ts[sub]}       \
             -y     ${gm2seq[sub]}          \
             -w     ${wm2seq[sub]}           \
             -c     ${csf2seq[sub]}          \
             -t     ${scorescrub_thresh[cxt]} \
             -o     ${outdir}/${prefix}

     output cbfscorets  ${prefix}_cbfscore_ts.nii.gz

    subroutine  @1.3 computing cbf scrubbing
 # compute the scrub 
        exec_xcp  scrub_cbf.R           \
            -i     ${cbfscorets[cxt]} \
            -y     ${gm2seq[sub]}           \
            -w     ${wm2seq[sub]}         \
            -c     ${csf2seq[sub]}          \
            -m     ${mask[sub]} \
            -t     ${scorescrub_thresh[cxt]} \
            -o     ${outdir}/${prefix}

   #aslqc 
   exec_xcp  aslqc.py -i ${cbfscore[cxt]}  -m ${mask[sub]} -g ${gm2seq[sub]} \
          -w ${wm2seq[sub]} -c ${csf2seq[sub]} -o ${outdir}/${prefix}_cbfscore
   

   qc cbfscore_qei   cbfscore_qei   ${prefix}_cbfscore_QEI.txt

   output  cbfscore_tsnr ${prefix}_cbfscore_tsnr.nii.gz

   exec_fsl fslmaths ${cbfscorets[cxt]} -Tmean ${intermediate}_cbfmean  
   exec_fsl fslmaths ${cbfscorets[cxt]}  -Tstd  ${intermediate}_cbfstd
   exec_fsl fslmaths ${intermediate}_cbfmean -div ${intermediate}_cbfstd \
   -mul ${mask[sub]}  ${cbfscore_tsnr[cxt]}

   qc cbfscoretsnr  cbfscoretsnr  ${prefix}_cbfscore_meantsnr.txt

   meanT1cbf=$(fslstats ${cbfscore_tsnr[cxt]}  -k  ${gm2seq[sub]} -M)
   echo ${meanT1cbf} >> ${cbfscoretsnr[cxt]}





   exec_xcp  aslqc.py -i ${cbfscrub[cxt]}  -m ${mask[sub]} -g ${gm2seq[sub]} \
          -w ${wm2seq[sub]} -c ${csf2seq[sub]} -o ${outdir}/${prefix}_cbfscrub
   
   qc cbfscrub_qei   cbfscrub_qei   ${prefix}_cbfscrub_QEI.txt
   #compute relative CBF 

   zscore_image ${cbfscrub[cxt]} ${cbfscrubZ[cxt]} ${mask[sub]} 
   zscore_image ${cbfscore[cxt]} ${cbfscoreZ[cxt]} ${mask[sub]} 

fi  
routine_end  

completion