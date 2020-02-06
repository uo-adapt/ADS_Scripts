#!/bin/bash

####################################################################
####################################################################

# SETUP FSL HERE (however it is done on your system)
module load fsl

# SETUP FREESUFER HERE (however it is done on your system)
module load freesurfer

####################################################################
####################################################################

export atlasBaseDir=${PWD}/atlas_data/
export scriptBaseDir=${PWD}/
# make a list from these options: 
# nspn500 gordon333 yeo17 yeo17dil hcp-mmp schaefer100-yeo17 
# schaefer200-yeo17 schaefer400-yeo17 schaefer600-yeo17 schaefer800-yeo17 
# schaefer1000-yeo17
export atlasList="gordon333 yeo17 hcp-mmp yeo17dil"

####################################################################
####################################################################
# subject variables

subj="sub-ADS1003"
echo $subj
subj=${SUBJ}
echo $subj
inputFSDir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/freesurfer/"${subj}""
outputDir="/projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/freesurfer/masks/"${subj}""
mkdir -p ${outputDir}

####################################################################
####################################################################
# go into the folder where we also want output and setup notes file!

cd ${outputDir}
OUT="maTT2_notes.txt"
touch $OUT

####################################################################
####################################################################
# run the script

# script inputs:
# -d          inputFSDir --> input freesurfer directory
# -o          outputDir ---> output directory, will also write temporary 
# -f          fsVersion ---> freeSurfer version (5p3 or 6p0)

############
# REMINDER #
############

# for maTT2 to function, download the .gcs files from: 
# https://doi.org/10.6084/m9.figshare.5998583.v1 
# and put these files into the respective 
# /atlas_data/{atlas}/ folders

start=`date +%s`

cmd="${scriptBaseDir}src/maTT2_applyGCS.sh \
        -d ${inputFSDir} \
        -o ${outputDir} \
        -f 6p0 \
    "
echo $cmd 
eval $cmd | tee -a ${OUT}

# record how long that took!
end=`date +%s`
runtime=$((end-start))
echo "runtime: $runtime"


