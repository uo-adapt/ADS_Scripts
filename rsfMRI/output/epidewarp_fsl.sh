#!/bin/bash

data_dir="/projects/adapt_lab/shared/ADS/data/BIDS_data/"
subid="sub-ADS4111"
wave="/ses-wave2/"

workspace="${data_dir}""${subid}""${wave}"

cd "${workspace}"/dwi

fslmaths "${workspace}"/fmap/"${subid}"_ses-wave2_phasediff.nii.gz -mul 3.14159 -div 4096 -div .00246 fieldmap.nii.gz

epidewarp.fsl --mag "${workspace}"/fmap/"${subid}"_ses-wave2_magnitude2.nii.gz --dph "${workspace}"/dwi/fieldmap.nii.gz --epi "${workspace}"/dwi/"${subid}"_ses-wave2_dwi.nii.gz --tediff 2.46 --esp 0.000400005 --vsm vox_shift_map.nii.gz --epidw test.nii.gz

fslview_deprecated "${subid}"_ses-wave2_dwi.nii.gz

rm test*
rm vox*
rm field*

