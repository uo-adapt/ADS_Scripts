#!/bin/bash
#

module load singularity
module load afni
module load ants
module load fsl
module load R
module load python3

cd /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine

export XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngi

./xcpEngine\
  -d /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_201903131537.dsn \
  -c /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine/rest_cohort.csv.sub-ADS1003,ses-wave2.csv \
  -i \$TMPDIR \
  -o /projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/xcpEngine/data 
