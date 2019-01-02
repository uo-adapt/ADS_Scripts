#/bin/bash
#
# This batch file calls on your subject
# list (named subject_list.txt). And 
# runs the job_fmriprep.sh file for 
# each subject. It saves the ouput
# and error files in their specified
# directories.
#
# Set your directories

group_dir=/projects/adapt_lab/shared/
#container=BIDS/SingularityContainers/poldracklab_fmriprep_latest-2017-07-20-dd77d76c5e14.img
container=containers/fmriprep-1.2.4.simg
study="ADS"

# Set bids directories
bids_dir="${group_dir}""${study}"/data/BIDS_data
derivatives="${bids_dir}"/derivatives
working_dir="${derivatives}"/working_bids_fmripreprest/
image="${group_dir}""${container}"

echo -e "\nFmriprep on $subid"
echo -e "\nContainer: $image"
echo -e "\nSubject directory: $bids_dir"

# Load packages
module load singularity

# Create working directory
mkdir -p $working_dir

# Run container using singularity
cd $bids_dir

#Source task list
task="rest"

#for task in $tasks; do

echo -e "\nStarting on: $task"
echo -e "\n"

export FS_LICENSE=/projects/adapt_lab/shared/ADS/Scripts/sMRI/license.txt

subid="ADS1021"

singularity run --bind "${group_dir}":"${group_dir}" ${image} ${bids_dir} ${derivatives} participant \
--participant_label ${subid} \
 -w ${working_dir} \
 -t ${task} --use-aroma --write-graph \
--output-space {'T1w','template','fsaverage5','fsnative'} \
--mem-mb 100000 \
--longitudinal \
--fs-license-file $FS_LICENSE
