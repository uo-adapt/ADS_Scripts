bet "$datadir"/sub-"${subid}"/ses-wave3/fmap/sub-"${subid}"_ses-wave3_magnitude2.nii.gz bet_magnitude1.nii.gz -f .5

fsl_prepare_fieldmap SIEMENS "$datadir"/sub-"${subid}"/ses-wave3/fmap/sub-"${subid}"_ses-wave3_phasediff.nii.gz bet_magnitude1.nii.gz fmap_rads 2.46



fugue -i sub-"${subid}"_ses-wave3_dwi.nii.gz --dwell=0.000400005 --loadfmap=fmap_rads -u dwi_corrected.nii