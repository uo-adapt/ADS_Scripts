#!/bin/tcsh

set bids_dir="${group_dir}""${study}"/data/BIDS_data
set derivatives="${bids_dir}"/derivatives
module load afni

set STUDY="${STUDY}"
set bids_dir="${STUDY}"/data/BIDS_data/
set derivatives="${bids_dir}"/derivatives
set SUBID="${SUBID}"

# AFNI-SUMA function: convert FS output
@SUMA_Make_Spec_FS                            \
    -NIFTI                                    \
    -fspath $derivatives/freesurfer/$SUBID    \
    -sid    $SUBID