#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run preproc_diff.sh
# for each subject in that list.

# Set your study
STUDY=/projects/adapt_lab/shared/ADS

# Set subject list
SUBJLIST=`cat subject_list_test.txt`
#SUBJLIST=`cat alignment.txt`

for SUBID in $SUBJLIST
 do sbatch --export=all,subid=${SUBID} --job-name diffpreproc --partition=short --mem-per-cpu=3G --time=3:00:00 --nodes=1 --cpus-per-task=1 -o "${STUDY}"/Scripts/dMRI/preproc/output/"${SUBID}"_diffpreproc_output.txt -e "${STUDY}"/Scripts/dMRI/preproc/output/"${SUBID}"_diffpreproc_error.txt preproc_diff.sh
done

