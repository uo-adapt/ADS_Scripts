#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_SUMA.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your study
STUDY=/projects/adapt_lab/shared/ADS

# Set subject list
#SUBJLIST=`cat sub_test.txt`
SUBJLIST=`cat sub_test.txt`
# 
for SUBJ in $SUBJLIST
do
 sbatch --export ALL,SUBID=${SUBJ},STUDY=${STUDY} --job-name SUMAprep_"${SUBJ}" --partition=short --time=1:00:00 --mem-per-cpu=2G --cpus-per-task=1 -o "${STUDY}"/Scripts/sMRI/output/"${SUBJ}"_SUMAprep_output.txt -e "${STUDY}"/Scripts/sMRI/"${SUBJ}"_SUMAprep_error.txt job_SUMA.sh
done

