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
SUBJLIST=`cat sub_test.txt`
#SUBJLIST=`cat test.txt`

# 
for SUBJ in $SUBJLIST
do
sbatch --export SUBID=${SUBJ} --job-name mapANNOTs_"${SUBJ}" --partition=short --mem-per-cpu=10G --cpus-per-task=1 -o "${STUDY}"/Scripts/sMRI/output/"${SUBJ}"_mapANNOTs_output.txt -e "${STUDY}"/Scripts/sMRI/output/"${SUBJ}"_mapANNOTs_error.txt job_map_annots.sh
done