#!/bin/bash
#

module load singularity
module load afni
module load ants
module load fsl
module load R
module load python3
cd /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine
export XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine
./xcpEngine\
  -d /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_201903131537.dsn \
  -c "${TEMP_COHORT}",${ses} \
  -i \$TMPDIR \
  -o /projects/adapt_lab/shared/ADS/data/BIDS_data/derivatives/xcpEngine/data 
