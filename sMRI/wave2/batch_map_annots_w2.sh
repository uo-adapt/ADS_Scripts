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
sbatch --export SUBID=${SUBJ} --job-name mapANNOTs_w2_"${SUBJ}" --partition=short --mem-per-cpu=1G --cpus-per-task=1 -o "${STUDY}"/Scripts/sMRI/wave2/output/"${SUBJ}"_mapANNOTs_w2_output.txt -e "${STUDY}"/Scripts/sMRI/wave2/output/"${SUBJ}"_mapANNOTs_w2_error.txt job_map_annots_w2.sh
done

