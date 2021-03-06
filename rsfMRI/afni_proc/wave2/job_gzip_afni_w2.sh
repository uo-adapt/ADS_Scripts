#!/bin/bash
#
# This script will convert afni files
# to gzipped nifti files
#

echo -e "\nSetting up AFNI"

module load afni

date

echo $SHELL
echo $SHLVL
echo ${SUBID}

# set subject and group identifiers
subj="${SUBID}"
echo $subj
group_id=ADS
echo $group_id
pipeline=rsfMRI_preproc_wave2

# set data directories
top_dir=/projects/adapt_lab/shared/"${group_id}"
echo $top_dir
rsfMRI_output=$top_dir/data/BIDS_data/derivatives/$pipeline/$subj/$subj.results
echo $rsfMRI_output

pushd $rsfMRI_output
ls *.BRIK > afnifiles.txt

afnifiles=`cat afnifiles.txt`
for i in $afnifiles
	do 
	filename=${i::-5}
	niftiname=${i::-10}
	echo $filename
	echo $niftiname
	3dAFNItoNIFTI $filename
	gzip $niftiname.nii
	rm $filename.BRIK
	rm $filename.HEAD
done

popd
