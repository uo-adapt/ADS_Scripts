#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the ants_be.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your directories

group_dir=/projects/adapt_lab/shared/
#container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-07-20-dd77d76c5e14.img
study="ADS"

# Set subject list
#SUBJLIST=`cat sublist_restw2_n84.txt`
SUBJLIST=`cat subject_list.txt`

# 
for SUBJ in $SUBJLIST; do

#SUBID=`echo $SUBJ|awk '{print $1}' FS=","`
#SESSID=`echo $SUBJ|awk '{print $2}' FS=","
	
sbatch --export ALL,subid=${SUBJ},group_dir=${group_dir},study=${study} --job-name ants_be_"${SUBJ}" --partition=short --time=2:00:00 --mem=15G -o "${group_dir}"/"${study}"/Scripts/rsfMRI/ants/output/"${SUBJ}"_ants_be_output.txt -e "${group_dir}"/"${study}"/Scripts/rsfMRI/ants/output/"${SUBJ}"_ants_be_error.txt ants_be.sh

done
