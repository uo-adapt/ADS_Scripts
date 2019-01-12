data_dir="/projects/adapt_lab/shared/ADS/data/BIDS_data/"
subid="sub-ADS4111"
wave="/ses-wave2/"

workspace="${data_dir}""${subid}""${wave}"

cd "${workspace}"/dwi

bet "${workspace}"fmap/"${subid}"_ses-wave2_magnitude2.nii.gz bet_magnitude1.nii.gz -f .5 -R


fslmaths bet_magnitude1.nii.gz -kernel sphere 4 -ero eroded_magnitude1.nii.gz

fsl_prepare_fieldmap SIEMENS "${workspace}"fmap/"${subid}"_ses-wave2_phasediff.nii.gz eroded_magnitude1.nii.gz fmap_rads 2.46 

fugue -i "${subid}"_ses-wave2_dwi.nii.gz --dwell=0.000046484061 --loadfmap=fieldmap.nii.gz -u dwi_corrected.nii

fslview_deprecated dwi_corrected.nii.gz





bet ../anat/"${subid}"_ses-wave2_T1w.nii.gz bet_T1w.nii.gz


epi_reg --epi="${subid}"_ses-wave2_dwi.nii.gz --t1=../anat/"${subid}"_ses-wave2_T1w.nii.gz --t1brain=<brain extracted T1 image> --fmap=fieldmap.nii.gz --out=epi_reg 