#!/bin/bash
#

module load singularity
module load afni
module load ants
module load fsl
module load c3d
module load R
module load python3

cd /projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine

XCPEDIR=/projects/adapt_lab/shared/ADS/Scripts/rsfMRI/xcpEngine
SIMG=/projects/adapt_lab/shared/containers/xcpEngine.simg
HOME=/projects/adapt_lab/shared/ADS

singularity run -B ${DATA_ROOT}:${HOME} $SIMG \
   -d ${HOME}/Scripts/rsfMRI/xcpEngine/fc-ICA-AROMA+GSR_201903060958.dsn \
   -c "${TEMP_COHORT}",${ses},${run} \
   -o ${HOME}/data/BIDS_data/derivatives/xcpEngine/data \
   -t 1 \
   -i \$TMPDIR

rm "${TEMP_COHORT}",${ses},${run}
