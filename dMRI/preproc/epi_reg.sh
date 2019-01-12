data_dir="/projects/adapt_lab/shared/ADS/data/BIDS_data/"
subid="sub-ADS4111"
wave="/ses-wave2/"

workspace="${data_dir}""${subid}""${wave}"

cd "${workspace}"/dwi

bet "${workspace}"fmap/"${subid}"_ses-wave2_magnitude1.nii.gz bet_magnitude1.nii.gz -f .5 -R

bet ../anat/"${subid}"_ses-wave2_T1w.nii.gz bet_T1w.nii.gz

fslmaths bet_magnitude1.nii.gz -kernel sphere 4 -ero eroded_magnitude1.nii.gz

fsl_prepare_fieldmap SIEMENS "${workspace}"fmap/"${subid}"_ses-wave2_phasediff.nii.gz eroded_magnitude1.nii.gz fmap_rads 2.46 

epi_reg --epi="${subid}"_ses-wave2_dwi.nii.gz --t1=../anat/"${subid}"_ses-wave2_T1w.nii.gz --t1brain=bet_T1w.nii.gz --fmap=fieldmap.nii.gz --fmapmag="${workspace}"fmap/"${subid}"_ses-wave2_magnitude1.nii.gz --fmapmagbrain=eroded_magnitude1.nii.gz --out=epi_reg --pedir=y- --echospacing=0.00046484061