#!/bin/bash

#Usage: srun preproc_diff.sh subject_list.txt

# This script will preprocess one diffusion imaging series with Aterior Posterior phase encoding directions.

# It extracts b0 volumes from each sequence, estimates the susceptibility induced off-resonance field, corrects for eddy current-induced distortion & movement, and estimates diffusion parameters & models crossing fibers at each voxel.

# This script uses FSL tools eddy_correct and dtifit.

# load fsl
module load fsl

# Set directory names
datadir="/projects/adapt_lab/shared/ADS/data/BIDS_data"
scriptsdir="/projects/adapt_lab/shared/ADS/Scripts/dMRI/preproc/wave2"
outputdir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/dMRI_preproc"

# Select options
masks="TRUE"

# Set error log file
errorlog=""$scriptsdir"/output/errorlog_preprocdiff.txt"

# Create error log file
touch "${errorlog}"

if [ $(ls "$datadir"/sub-"${subid}"/ses-wave2/dwi/*.nii.gz | wc -l) -eq 1 ]; then

# Extract B0 images from nifti files & combine in single volume.
mkdir -p "$outputdir"/"${subid}"/ses-wave2/
cd "$outputdir"/"${subid}"/ses-wave2/
cp -R "$datadir"/sub-"${subid}"/ses-wave2/dwi .
cd dwi/
echo making "${subid}" b0 image
fslroi sub-"${subid}"_ses-wave2_dwi.nii.gz b0_1 0 -1 0 -1 0 -1 0 1
fslroi sub-"${subid}"_ses-wave2_dwi.nii.gz b0_2 0 -1 0 -1 0 -1 10 1
fslmerge -a b0_merge b0_1.nii.gz b0_2.nii.gz

# Preparing to run eddy_correct
fslmaths b0_merge.nii.gz -Tmean b0_merge_mean
bet b0_merge_mean.nii.gz b0_bet_brain -m

# Find a way to make new files titled 'bvals' 'bvecs'[]
cp sub-"${subid}"_ses-wave2_dwi.bval bvals
cp sub-"${subid}"_ses-wave2_dwi.bvec bvecs

echo running "${subid}" eddy_correct
eddy_correct sub-"${subid}"_ses-wave2_dwi.nii.gz sub-"${subid}"_ses-wave2_dwi_eddy_correct.nii.gz b0_bet_brain_mask.nii.gz
cp b0_bet_brain_mask.nii.gz nodif_brain_mask.nii.gz
cp sub-"${subid}"_ses-wave2_dwi_eddy_correct.nii.gz data.nii.gz

# [Register it to the brain extracted freesurfer output]
# convert freesurfer brain.mgz to nifti 
# MRI Convert to nifti
# fslrieront2std brain.nii.gz brain_reor

# Linear registration of mprage to standard space
mkdir reg
cd reg
echo "${subid}" linear registration mprage to MNI


# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting "${subid}" tensors at each voxel
cd "$outputdir"/"${subid}"/ses-wave2/dwi
dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r bvecs -b bvals -w

# if epi_reg, B0 -> freesurfer (BET) -> use omat to register FA to freesurfer (BET)

# flirt FA or use EPI_reg to brain extracted freesurfer output

cd "$outputdir"/"${subid}"/ses-wave2/anat/reg
echo "${subid}" linear registration FA map to mprage
/packages/fsl/5.0.10/install/bin/flirt -in "$outputdir"/"${subid}"/ses-wave2/dwi/dti_FA.nii.gz -ref "$outputdir"/"${subid}"/ses-wave2/anat/[freesurfer brain] -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting "${subid}" FA-to-structural transformation
/packages/fsl/5.0.10/install/bin/convert_xfm -omat struct2FA.mat -inverse "$outputdir"/"${subid}"/ses-wave2/anat/reg/FA2struct.mat



else
# Making a note of missing files in error log
echo "ERROR: no files; nothing to preprocess"
echo "$datadir"/sub-"${subid}"/ses-wave2/dwi: MISSING DIFFUSION SEQUENCES >> $errorlog
fi

