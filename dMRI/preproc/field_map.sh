data_dir="/projects/adapt_lab/shared/ADS/data/BIDS_data/"
subid="sub-ADS4111"
wave="/ses-wave2/"

workspace="${data_dir}""${subid}""${wave}"

cd "${workspace}"/dwi

bet "${workspace}"fmap/"${subid}"_ses-wave2_magnitude2.nii.gz bet_magnitude1.nii.gz -f .6

fsl_prepare_fieldmap SIEMENS "${workspace}"fmap/"${subid}"_ses-wave2_phasediff.nii.gz bet_magnitude1.nii.gz fmap_rads 2.46



fugue -i "${subid}"_ses-wave2_dwi.nii.gz --dwell=0.000400005 --loadfmap=fmap_rads -u dwi_corrected.nii