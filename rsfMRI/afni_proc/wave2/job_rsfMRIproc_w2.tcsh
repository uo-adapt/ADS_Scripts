#!/bin/tcsh
#
# This script calls from the variables set in batch_rsfMRIproc.sh
# and uses afni_proc.py to generate a participant-specific resting
# state preprocessing script, which will:
#
#  a) live in the participants' folder
#  b) be named t{SUBID}.proc
#  c) execute automatically.
#
echo -e "\nSetting up AFNI"
#module load prl R/3.3.3 afni
#module load prl
module load afni

date

echo $SHELL
echo $SHLVL
echo ${SUBID}

# set subject and group identifiers
set subj="${SUBID}"
echo $subj
set group_id=ADS
echo $group_id
set wave=ses-wave2
set pipeline=rsfMRI_preproc_wave2
set STUDY="${STUDY}"
set bids_dir="${STUDY}"/data/BIDS_data

# set data directories
set top_dir="${STUDY}"
echo $top_dir
set anat_dir=$bids_dir/derivatives/freesurfer/"${subj}"_ses-wave2.long.$subj/SUMA
echo $anat_dir
set epi_dir=$bids_dir/"$subj"/"${wave}"/func
echo $epi_dir
set rsfMRI_output=$bids_dir/derivatives/$pipeline
echo $rsfMRI_output

# create subject folder
pushd $rsfMRI_output
if (! -d ./"$subj") then
   echo '"$subj" folder created'
   mkdir "$subj"
   cd "$subj"
else
   echo 'Directory for "$subj" exists'
   rm -r "$subj"   
   mkdir "$subj"
   cd "$subj"
endif


# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id $subj                                \
-script $pipeline.proc.$subj -scr_overwrite                          \
-blocks despike align volreg mask scale regress      \
-copy_anat $anat_dir/"${subj}"_SurfVol.nii.gz                          \
-anat_follower_ROI aaseg anat $anat_dir/aparc.a2009s+aseg_rank.nii.gz   \
-anat_follower_ROI aeseg epi  $anat_dir/aparc.a2009s+aseg_rank.nii.gz   \
-anat_follower_ROI FSvent epi $anat_dir/"${subj}"_vent.nii.gz           \
-anat_follower_ROI FSWe epi $anat_dir/"${subj}"_WM.nii.gz            \
-anat_follower_erode FSvent FSWe                           \
-dsets $epi_dir/"${subj}"_"${wave}"_task-rest_bold.nii.gz \
-tcat_remove_first_trs 5                                  \
-volreg_align_to MIN_OUTLIER                               \
-volreg_align_e2a                                          \
-align_opts_aea -giant_move -cost lpc+ZZ                   \
-volreg_interp -Fourier \
-mask_epi_anat yes \
-mask_test_overlap yes \
-scale_max_val 200 \
-regress_compute_gcor yes \
-regress_ROI_PC FSvent 3                                   \
-regress_make_corr_vols aeseg FSvent                       \
-regress_anaticor_fast                                     \
-regress_anaticor_label FSWe                               \
-regress_censor_outliers 0.1                               \
-regress_censor_motion 0.2                                \
-regress_bandpass 0.009 0.2                               \
-regress_apply_mot_types demean deriv                      \
-regress_run_clustsim no                                  

tcsh -xef $pipeline.proc.$subj
