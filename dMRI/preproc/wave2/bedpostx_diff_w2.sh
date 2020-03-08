#!/bin/bash

# This script fits a probabilistic diffusion model to diffusion data that have already been motion-corrected & preprocessed using preproc_diff.sh

# Load FSL
module load fsl


# Set directory names
datadir="/projects/adapt_lab/shared/ADS/data/BIDS_data"
scriptsdir="/projects/adapt_lab/shared/ADS/Scripts/dMRI/preproc/wave2"
outputdir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/dMRI_preproc"

# Set file dependencies
data=""$outputdir"/"${subid}"/ses-wave2/dwi/data.nii.gz"
bvecs=""$outputdir"/"${subid}"/ses-wave2/dwi/bvecs"
bvals=""$outputdir"/"${subid}"/ses-wave2/dwi/bvals"
b0mask=""$outputdir"/"${subid}"/ses-wave2/dwi/nodif_brain_mask.nii.gz"

# Set error log file
errorlog=""$scriptsdir"/output/errorlog_bedpostx.txt"

# Create error log file
touch "${errorlog}"

for wave in wave2 wave3

do
if [[ -f "$data" && -f "$bvecs" && -f "$bvals" && -f "$b0mask" ]]; then
# Fitting a probabilistic diffusion model
# Note: This last command takes a couple days to run
echo running "${subid}" bedpostx
bedpostx "$outputdir"/"${subid}"/ses-${wave}/dwi

echo "${subid}" preprocessing completed. Next step - tractography.
# Congratulations!  You are now ready to perform tractography.

else
# Making a note of missing files in error log
echo "ERROR: missing at least one file necessary for fitting diffusion model"
echo "$outputdir"/"${subid}"/ses-${wave}/dwi: MISSING BEDPOSTX INPUT FILES >> $errorlog
fi

done