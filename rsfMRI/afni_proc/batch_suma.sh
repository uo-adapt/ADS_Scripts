#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_rsfMRIproc_w2.tcsh
# for each subject in that list.

# Set your study
STUDY=/projects/adapt_lab/shared/ADS

# Set subject list
#SUBJLIST=`cat sublist_restw2_n84.txt`
SUBJLIST=`cat  sub_test.txt`

for SUBJ in $SUBJLIST
 do sbatch --export ALL,SUBID=${SUBJ},STUDY=${STUDY} --job-name suma_"${SUBJ}" --partition=short --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/Scripts/rsfMRI/afni_proc/output/"${SUBJ}"_suma_output.txt -e "${STUDY}"/Scripts/rsfMRI/afni_proc/output/"${SUBJ}"_suma_error.txt job_suma.tcsh
done