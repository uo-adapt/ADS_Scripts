#!/bin/bash

#Usage: srun preproc_diff.sh subject_list.txt

# This script will preprocess one diffusion imaging series with Aterior Posterior phase encoding directions.

# It extracts b0 volumes from each sequence, estimates the susceptibility induced off-resonance field, corrects for eddy current-induced distortion & movement, and estimates diffusion parameters & models crossing fibers at each voxel.

# This script uses FSL tools eddy_correct and dtifit.

# load fsl and freesurfer
module load fsl
module load freesurfer
source /projects/adapt_lab/shared/ADS/Scripts/sMRI/SetUpFreeSurfer.sh

# Set directory names
datadir="/projects/adapt_lab/shared/ADS/data/BIDS_data"
scriptsdir="/projects/adapt_lab/shared/ADS/Scripts/dMRI/preproc/wave2"
outputdir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/dMRI_preproc"
freesurferdir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/freesurfer"

# Select options
masks="TRUE"

# Set error log file
errorlog=""$scriptsdir"/output/errorlog_preprocdiff.txt"

# Create error log file
touch "${errorlog}"

for wave in wave2 wave3

do
if [ $(ls "$datadir"/sub-"${subid}"/ses-"${wave}"/dwi/*.nii.gz | wc -l) -eq 1 ]; then

# Extract B0 images from nifti files & combine in single volume.
mkdir -p "$outputdir"/"${subid}"/ses-${wave}/
cd "$outputdir"/"${subid}"/ses-${wave}/
cp -R "$datadir"/sub-"${subid}"/ses-${wave}/dwi .
cd dwi/
echo making "${subid}" b0 image
fslroi sub-"${subid}"_ses-${wave}_dwi.nii.gz b0_1 0 -1 0 -1 0 -1 0 1
fslroi sub-"${subid}"_ses-${wave}_dwi.nii.gz b0_2 0 -1 0 -1 0 -1 10 1
fslmerge -a b0_merge b0_1.nii.gz b0_2.nii.gz

# Preparing to run eddy_correct
fslmaths b0_merge.nii.gz -Tmean b0_merge_mean
bet b0_merge_mean.nii.gz b0_bet_brain -m

# Find a way to make new files titled 'bvals' 'bvecs'[]
cp sub-"${subid}"_ses-${wave}_dwi.bval bvals
cp sub-"${subid}"_ses-${wave}_dwi.bvec bvecs

echo running "${subid}" eddy_correct
eddy_correct sub-"${subid}"_ses-${wave}_dwi.nii.gz sub-"${subid}"_ses-${wave}_dwi_eddy_correct.nii.gz b0_bet_brain_mask.nii.gz
cp b0_bet_brain_mask.nii.gz nodif_brain_mask.nii.gz
cp sub-"${subid}"_ses-${wave}_dwi_eddy_correct.nii.gz data.nii.gz

# Linear registration of brain extracted freesurfer to standard space
cd "$outputdir"/"${subid}"/ses-${wave}/
mkdir anat
mkdir anat/reg
cd anat/reg
echo "${subid}" linear registration mprage to MNI

# convert freesurfer brain extracted brainmask.mgz to nifti 
mri_convert --in_type mgz --out_type nii --out_orientation RAS "${freesurferdir}"/sub-"${subid}"/mri/brainmask.mgz brainmask.nii.gz

# lineart transform the brainmask.nii.gz to MNI space and create a transformation matrix
flirt -in brainmask.nii.gz -ref ${FSLDIR}/data/standard/MNI152_T1_1mm_brain -out brainmask_MNI.nii.gz -omat brainmask2mni.mat -dof 6

# convert freesurfer non-brain extracted brain.mgz to nifti 
mri_convert --in_type mgz --out_type nii --out_orientation RAS "${freesurferdir}"/sub-"${subid}"/mri/brain.mgz brain.nii.gz

# nonlineart transform the brain.nii.gz to MNI space using the previously generated transformation matrix
fnirt --in=brain.nii.gz --config=T1_2_MNI152_2mm.cnf --aff=brainmask2mni.mat --iout=brain2mni.nii.gz --cout=brain_warpcoef

# Fitting diffusion tensors at each voxel.  This step outputs eigenvectors, mean diffusivity, & fractional anisotropy
echo fitting "${subid}" tensors at each voxel
cd "$outputdir"/"${subid}"/ses-${wave}/dwi
dtifit -k data.nii.gz -o dti -m nodif_brain_mask.nii.gz -r bvecs -b bvals -w

# flirt FA to brain extracted freesurfer output

cd "$outputdir"/"${subid}"/ses-${wave}/anat/reg
echo "${subid}" linear registration FA map to freesurfer
flirt -in "$outputdir"/"${subid}"/ses-${wave}/dwi/dti_FA.nii.gz -ref "$outputdir"/"${subid}"/ses-${wave}/anat/brainmask.nii.gz -out FA2struct -omat FA2struct.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -interp trilinear

# Inverse of transformation above (i.e., creating image to transform standard-space masks into diffusion space)
echo inverting "${subid}" FA-to-structural transformation
/packages/fsl/5.0.10/install/bin/convert_xfm -omat struct2FA.mat -inverse "$outputdir"/"${subid}"/ses-${wave}/anat/reg/FA2struct.mat



else
# Making a note of missing files in error log
echo "ERROR: no files; nothing to preprocess"
echo "$datadir"/sub-"${subid}"/ses-${wave}/dwi: MISSING DIFFUSION SEQUENCES >> $errorlog
fi

done
