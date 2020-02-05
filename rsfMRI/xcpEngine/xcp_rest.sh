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
SIMG=/projects/adapt_lab/shared/containers/xcpEngine.simg
HOME=/projects/adapt_lab/shared/ADS

./xcpEngine\
   -d ${HOME}/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA_202002041521.dsn \
   -c "${TEMP_COHORT}",${ses} \
   -o ${HOME}/data/BIDS_data/derivatives/xcpEngine/data \
   -t 2 \
   -i \$TMPDIR

