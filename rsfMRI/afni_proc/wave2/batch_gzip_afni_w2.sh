#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt) in the same
# folder and will run job_gzip_afni_w2.sh
# for each subject in that list.

# Set your study
STUDY=/projects/adapt_lab/shared/ADS

# Set subject list
SUBJLIST=`cat sub_test.txt`

for SUBJ in $SUBJLIST
 do sbatch --export SUBID=${SUBJ} --job-name gzipit --partition=short --mem-per-cpu=3G --cpus-per-task=1 -o "${STUDY}"/Scripts/rsfMRI/afni_proc/wave2/output/"${SUBJ}"_gzipit_output_w2.txt -e "${STUDY}"/Scripts/rsfMRI/afni_proc/wave2/output/"${SUBJ}"_gzipit_error_w2.txt job_gzip_afni_w2.sh
done

