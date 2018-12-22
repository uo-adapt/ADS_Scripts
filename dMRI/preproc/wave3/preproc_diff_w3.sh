#!/bin/bash

#Usage: srun preproc_diff.sh subject_list.txt

# This script will preprocess one diffusion imaging series with Aterior Posterior phase encoding directions.

# It extracts b0 volumes from each sequence, estimates the susceptibility induced off-resonance field, corrects for eddy current-induced distortion & movement, and estimates diffusion parameters & models crossing fibers at each voxel.

# This script uses FSL tools eddy_correct and dtifit.

# load fsl
module load fsl

# Set directory names
datadir="/projects/adapt_lab/shared/ADS/data/BIDS_data"
scriptsdir="/projects/adapt_lab/shared/ADS/Scripts/dMRI/preproc/wave3"
outputdir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/dMRI_preproc"

# Select options
masks="TRUE"

# Set error log file
errorlog=""$scriptsdir"/output/errorlog_preprocdiff.txt"

# Create error log file
touch "${errorlog}"

if [ $(ls "$datadir"/sub-"${subid}"/ses-wave3/dwi/*.nii.gz | wc -l) -eq 1 ]; then

# Extract B0 images from nifti files & combine in single volume.
mkdir -p "$outputdir"/"${subid}"/ses-wave3/
cd "$outputdir"/"${subid}"/ses-wave3/
cp -R "$datadir"/sub-"${subid}"/ses-wave3/dwi .
cd dwi/
echo making "${subid}" b0 image
fslroi sub-"${subid}"_ses-wave3_dwi.nii.gz b0_1 0 -1 0 -1 0 -1 0 1
fslroi sub-"${subid}"_ses-wave3_dwi.nii.gz b0_2 0 -1 0 -1 0 -1 10 1
fslmerge -a b0_merge b0_1.nii.gz b0_2.nii.gz

# Preparing to run eddy_correct
fslmaths b0_merge.nii.gz -Tmean b0_merge_mean
bet b0_merge_mean.nii.gz b0_bet_brain -m

# Find a way to make new files titled 'bvals' 'bvecs'[]
cp sub-"${subid}"_ses-wave3_dwi.bval bvals
cp sub-"${subid}"_ses-wave3_dwi.bvec bvecs

echo running "${subid}" eddy
eddy_correct sub-"${subid}"_ses-wave3_dwi.nii.gz sub-"${subid}"_ses-wave3_dwi_eddy_correct.nii.gz b0_bet_brain_mask.nii.gz
cp b0_bet_brain_mask.nii.gz nodif_brain_mask.nii.gz
cp sub-"${subid}"_ses-wave3_dwi_eddy_correct.nii.gz data.nii.gz

# Registration
cd "$outputdir"/"${subid}"/ses-wave3/
cp -R "$datadir"/sub-"${subid}"/ses-wave3/anat .
cd "$outputdir"/"${subid}"/ses-wave3/anat
standard_space_roi sub-"${subid}"_ses-wave3_T1w.nii.gz mprage_ssroi -b
# bet .2 is threshold, check to make sure okay
bet mprage_ssroi.nii.gz mprage_brain -f .2 -m

# Linear registration of mprage to standard space
mkdir reg
cd reg
echo "${subid}" linear registration mprage to MNI
/packages/fsl/5.0.10/install/bin/flirt -in "$outputdir"/"${subid}"/ses-wave3/anat/mprage_brain.nii.gz -ref /packages/fsl/5.0.10/install/data/standard/MNI152_T1_2mm_brain -out "$outputdir"/"${subid}"/ses-wave3/anat/reg/struct2mni -omat "$outputdir"/"${subid}"/ses-wave3/anat/reg/struct2mni.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# Non-linear warp of linear registration
echo warping "${subid}" registration nonlinearly
fnirt --in=../sub-"${subid}"_ses-wave3_T1w.nii.gz --aff=struct2mni.mat --cout=struct2mni_warp --ref=/packages/fsl/5.0.10/install/data/standard/MNI152_T1_2mm_brain.nii.gz

# Inverting non-linear warp
echo inverting "${subid}" non-linear warp
invwarp --ref=../mprage_brain.nii.gz --warp=struct2mni_warp.nii.gz --out=mni2struct_warp

# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting "${subid}" tensors at each voxel
cd "$outputdir"/"${subid}"/ses-wave3/dwi
dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r bvecs -b bvals -w

cd "$outputdir"/"${subid}"/ses-wave3/anat/reg
echo "${subid}" linear registration FA map to mprage
/packages/fsl/5.0.10/install/bin/flirt -in "$outputdir"/"${subid}"/ses-wave3/dwi/dti_FA.nii.gz -ref "$outputdir"/"${subid}"/ses-wave3/anat/mprage_brain.nii.gz -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting "${subid}" FA-to-structural transformation
/packages/fsl/5.0.10/install/bin/convert_xfm -omat struct2FA.mat -inverse "$outputdir"/"${subid}"/ses-wave3/anat/reg/FA2struct.mat



else
# Making a note of missing files in error log
echo "ERROR: no files; nothing to preprocess"
echo "$datadir"/sub-"${subid}"/ses-wave3/dwi: MISSING DIFFUSION SEQUENCES >> $errorlog
fi

