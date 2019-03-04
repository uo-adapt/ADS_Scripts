#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_vols2timecourses_w2.sh
# for each subject in that list.
#

# Set your study
STUDY=/projects/adapt_lab/shared/ADS

# Set subject list
SUBJLIST=`cat sub_test.txt`


for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name vols2timecourses_w2 --partition=short --mem-per-cpu=8G --cpus-per-task=1 -o "${STUDY}"/Scripts/rsfMRI/afni_proc/wave_2/output/"${SUBJ}"_vols2timecourses_w2output.txt -e "${STUDY}"/Scripts/rsfMRI/afni_proc/wave_2/output/"${SUBJ}"_vols2timecourses__w2error.txt job_vols2timecourses_w2.sh
done
