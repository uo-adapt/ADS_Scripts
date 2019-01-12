#!/bin/bash
#
# This batch file calls on your subject
# list (named subject_list_sam.txt) in the same
# folder and will run preproc_diff.sh
# for each subject in that list.


sbatch --export=all --job-name epiSreg --partition=short --mem-per-cpu=25G --time=3:00:00 --nodes=1 --cpus-per-task=1 epi_reg.sh



