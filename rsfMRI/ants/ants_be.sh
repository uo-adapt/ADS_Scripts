#/bin/bash
#
# This script calls on brain
# extraction tool to use on 
# the fmriprep output files
# it then makes a /struc
# folder within fmriprep/sub-xxx/anat
# folder and makes a N4 corrected,
# brain extracted image for the 
# xcpEngine func pipeline
#
# Set your directories

group_dir=/projects/adapt_lab/shared/
study="ADS"

# Set bids directories
bids_dir="${group_dir}""${study}"/data/BIDS_data
derivatives="${bids_dir}"/derivatives
image="${group_dir}""${container}"
subjectdir="${bids_dir}"/derivatives/fmriprep/${subid}/anat

echo -e "\ants on $subid"

# Load packages
module load ants

# Create working directory
mkdir struc

# cd into subject folder
cd $subjectdir

# set XCPEDIR
export XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine

antsBrainExtraction.sh -d 3 -a ${subid}_desc-preproc_T1w.nii.gz -e $XCPEDIR/space/MNI/MNI-1x1x1Head.nii.gz -f $XCPEDIR/space/MNI/MNI-1x1x1MaskDilated.nii.gz -m $XCPEDIR/space/MNI/MNI-1x1x1BrainPrior.nii.gz -k 0 -q 0 -u 0 -z 0 -o./struc/${subid}_ -s _ExtractedBrain0N4.nii.gz

